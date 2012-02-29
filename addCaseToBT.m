function [tree] = addCaseToBT(tree, newcase)

  if isequal(tree.nodeCase, [])
    tree.nodeCase = newcase;
    tree.leftChild.nodeCase = [];
    tree.rightChild.nodeCase = [];
  else

    comparison = compareCaseBin(tree.nodeCase, newcase);

    if comparison < 0
      tree.leftChild = addCaseToBT(tree.leftChild, newcase);
    elseif comparison > 0
      tree.rightChild = addCaseToBT(tree.rightChild, newcase);
    else
      t = tree.nodeCase.typicality;
      t = t + newcase.typicality;
      tree.nodeCase.typicality = t;
    end


  end





end
