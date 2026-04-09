function data_array_N = GFCN_get_K_samples(data_array, K, center, kernelType, sigma)
    label_unique = unique(data_array(:,end));
    data_array_cell = cell(1, max(label_unique));
    for label_ii = 1:length(label_unique)
        label_i = label_unique(label_ii);
        label_i_indx = data_array(:, end) == label_i;
        label_i_samples = data_array(label_i_indx, :);
        label_i_center = center(label_ii, :);
        label_i_features = label_i_samples(:, 1:end-1);

        if(nargin <= 3)
            similarities = zeros(size(label_i_features, 1), 1);
            for label_i_samples_i = 1:size(label_i_features, 1)
                label_i_samples_vec = label_i_features(label_i_samples_i, :);
                x_y_distance = norm(label_i_center - label_i_samples_vec);
                similarities(label_i_samples_i) = x_y_distance;
            end
        else
            similarities = fuzzySimilarity(label_i_center, label_i_features, kernelType, sigma);
        end

        [~, sort_indices] = sort(similarities, 'descend');
        label_i_sorted_samples = label_i_samples(sort_indices, :);
        data_array_cell{label_i} = label_i_sorted_samples;
    end

    k_samples = K;
    data_array_New = [];
    for label_ii = 1:length(label_unique)
        label_i = label_unique(label_ii);
        data_array_cell_i = data_array_cell{label_i};
        data_array_cell_i_numbers = size(data_array_cell_i, 1);
        if(data_array_cell_i_numbers < k_samples)
            data_array_New = [data_array_New; data_array_cell_i];
        else
            data_array_New = [data_array_New; data_array_cell_i(1:k_samples, :)];
        end
    end
    data_array_N = data_array_New;
end