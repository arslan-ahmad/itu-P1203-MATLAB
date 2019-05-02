function y = execute_tree(features, tree_matrix)
    function x =  recurse_execute(node_id)
        feature_id = tree_matrix(node_id,2);
        feature_thres = tree_matrix(node_id,3);
        left_child = tree_matrix(node_id,4);
        right_child = tree_matrix(node_id,5);

        if(feature_id == -1)
            x = feature_thres;
        elseif (features(feature_id) < feature_thres)
            x = recurse_execute(left_child);
        else
            x = recurse_execute(right_child);
        end
        end
        y = recurse_execute(1);
      end
