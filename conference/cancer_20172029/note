Scripts for cancer conference 20170929.
Two machine learning methods were applied for classification between somatic and germline cancer genome.
These two scripts are on the way of completion and there are many future works.
In the future works (as of 20171001),
    1. Normalization - Scales should be set to be the same range, especiall for logistic regression.
        The data that spreads in a small range has disadvantage for making separating phase, but it that true ?
        (R package (glm) converts data into fitting z distribution for testing and gets pvalue.)
    2. Cross validation - Testing data should be undergone the cross validation due to the weakness of decision tree algorithms.
        Actually the learning model was changed as random seeds made for static testing data changed.
    3. Evalutation - As the test data is randomly sampled, the learning and its result should be undergone 
        for many times and the average among the distribution should be calculated.
    4. Other algorithms - Such as svm and neural networks will improve the mismatch ratio of prediction, 
        but this times's study already gives enough yields for classification (over 98%). 
        The problems are that if the amount of data is actual size (not 10e3 order but 10e7~), .
    5. Error of first kind - the ratio of error from somatic to germline is more important, 
        because if this machine learning prediction was installed in the actual clinical fields this kind of error is fatal.

Under construction
    1. Two steps model - Filter by Exac is applied before learning, because germline exac under 0.1 are not confident.
    2. 



