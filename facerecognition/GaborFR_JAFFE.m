function [recogResult]= GaborFR_JAFFE(trainImagePath, testImagePath, imageLable)
%% CCFR recognition the facial expression
%TRAINIMAGEPATH      ---Train image path
%TESTIMAGEPATH      ---Test image path
%IMAGELABLE      ---The infomation of trainning set
%RECOGRESULT      ---Whether the test is successful.

%%
disp('This Program is written by DIP&PG Group');
fprintf('Computing Center\nSchool of Science and Engineering\nEast China Normal University\n');
disp('Any questions, please contact cisjiong@gmail.com');

recogResult = 0;


%% ################# Initialization and Checking  ########################
%Checking file and folder path
fprintf('\nChecking file path and initialization...\n');
if(isempty(trainImagePath))
    trainImagePath = input('Please input the train image folder:', 's');
end

if(isempty(testImagePath))
    testImagePath = input('Please input the test image folder:', 's');
end

if(isempty(imageLable))
    imageLable = input('Please input the label file:', 's');
end

%Initialize image and lable file name
fid = fopen(imageLable);
imageLabel = textscan(fid, '%s %s', 'whitespace', ',');
fclose(fid);

%Whether neutral facial expression exist
neutralFace = [];
for i = 1 : length(imageLabel{1, 1})
    if (strcmp(imageLabel{1, 2}{i, 1}, 'neutral'))
        neutralFace = [neutralFace, i];
    end
end

if (isempty(neutralFace))
    disp('Error: missing neutral facial expression in training set');
    return;
end

testImageFolder = dir(testImagePath);
trainImageNum = length(imageLabel{1, 1});
testImageNum = length(testImageFolder);

if (testImageNum == 0)
    disp('Error: no image for testing, please check you test image path');
    return;
end

%Get all train image name and test image name
trainImages = '';
for i = 1 : trainImageNum
 	trainImages{i,1} = strcat(trainImagePath,'\',imageLabel{1,1}(i));
end

testImages = '';
j = 0;
for i = 3 : testImageNum
    if ((~testImageFolder(i).isdir))
        if (strcmp(testImageFolder(i).name(end - 4 : end), '.tiff'))
            j = j + 1;
            testImages{j, 1} = [testImagePath, '\', testImageFolder(i).name];
        end
    end
end

testImageNum = j;
%Get 24 Gabor filters;
ratio = 3;
localRegionNum = (2 * ratio - 1)^2;
gaborFilters = GenGaborFilter;

 %% ################# Load train image and  preprocess  ########################
 fprintf('\nTrain stage: load image and process\n');
 trainImg = zeros(720 * localRegionNum * 3, trainImageNum);
 for i = 1 : trainImageNum
     fprintf('Loading train image # %d...\n', i);
     %img = imresize(detect_face(imresize(imread(cell2mat(trainImages{i,1})),[375,300])),imageSize);
     fname = cell2mat(trainImages{i,1});
     img = preprocessing(imread(fname), imfinfo(fname));
     img = FeatureExtract(img, 164, 127, gaborFilters, ratio);
     trainImg(:, i) = img(:);
 end
 %imshow(img);
 
 
 %% ################# PCA low dimension space construction ########################
 meanTrainImage = mean(trainImg, 2);
 trainImg = (trainImg - meanTrainImage * ones(1, trainImageNum))';
 
 %econ  p is much larger than n
 [COEFF, SCORE] = princomp(trainImg, 'econ'); 
 %which eigenvalues will be selected
 eigenRange = [1 : 10]; 
 COEFF = COEFF(:, eigenRange);
 

 %% ############ Load test image and use PCA project on low dimension space ##############
 fprintf('\nTest stage: load image and process\n');
 testImg = zeros(720 * localRegionNum * 3, testImageNum);
 for i = 1 : testImageNum
     fprintf('Loading test image # %d...\n', i);
     %img = imresize(detect_face(imresize(imread(testImages{i,1}),[375,300])),imageSize);
     fname = testImages{i,1};
     img = preprocessing(imread(fname), imfinfo(fname));
     %figure, imshow(img);
     img = FeatureExtract(img, 164, 127, gaborFilters, ratio);
     testImg(:, i) = img(:);
 end
 %figure, imshow(img);
 meanTestImage = mean(testImg, 2);
 testImg = (testImg - meanTestImage * ones(1, testImageNum))';
 %project test image to low dimension space
 projectedTestImage = testImg * COEFF; 
 

%% ################# Calculation of euclid distance from neutral images##################
fprintf('\nRecognition: calculate the distance and make decision\n');
meanNeutralImage = mean(SCORE(neutralFace, eigenRange)', 2);
neutralEuclidDis = zeros(testImageNum);
for i = 1 : testImageNum
    testMatrice = projectedTestImage(i, :);
    neutralEuclidDis(i) = sqrt((testMatrice' - meanNeutralImage)' * (testMatrice' - meanNeutralImage));
end

%% ################# Calculation of euclid distance from other train images##################
otherEuclidDis = zeros(testImageNum, trainImageNum);
for i = 1 : testImageNum
    testMatrice = projectedTestImage(i, :);
    for j = 1 : trainImageNum
        otherEuclidDis(i, j) = sqrt((testMatrice' - SCORE(j, eigenRange)')' * (testMatrice' - SCORE(j, eigenRange)'));
    end
end
[minDist, minPos] = min(otherEuclidDis, [], 2);


%% #################Recognite and save the result int the text##################
fid = fopen('result_cross_1_3.txt', 'w');
fprintf(fid, 'Test Image, Distance From Neutral Expression, Best Match\r\n');

for i = 1 : testImageNum
    indices = find(testImages{i, 1} == '\');
    TESTIMAGES = testImages{i, 1}(indices(end) + 1 : end);
    distFromNeutral = neutralEuclidDis(i);
    bestMatch = cell2mat(imageLabel{1, 1}(minPos(i)));
    expression = cell2mat(imageLabel{1, 2}(minPos(i)));
    fprintf(fid, '%s, %0.0f, %s, %s\r\n', TESTIMAGES, distFromNeutral, expression, bestMatch);
end
fclose(fid);


%% #################Over##################
recogResult = 1;
fprintf('All done, please openGaborResult.txt to see the result\n');
