%% test face recognition system for one image

%[projected_face, matrix_pca, matrix_rfld] = train_stage('.\yale', 'label_yale.txt');
test_face = imread('A (2).bmp');
test_face = double(test_face(:)');
test_face = test_face * matrix_pca;
[n, d] = size(projected_face);

dis = zeros(n, 1);
for i = 1 : n
    for j = 1 : d
        dis(i) = dis(i) + (projected_face(i, j) - test_face(j)) ^ 2;
    end
end

[C, I] = min(dis);
fprintf('distance is %d, indice is %d\n', C, I);