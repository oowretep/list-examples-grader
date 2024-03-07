CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission 2> git_output.txt
echo 'Finished cloning'

if ! [[ -f student-submission/ListExamples.java ]]
then
    echo "Missing student-submission/ListExamples.java"
    echo -e "\n"
    echo "Check to see if your ListExamples.java is in the correct directory (student-submission)"
    echo -e "\n"
    echo "Or check to see if submission has the right filename (ListExamples.java)"
    echo -e "\n"
    exit
fi

cp student-submission/ListExamples.java TestListExamples.java grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java

if [[ $? -ne 0 ]] 
then
    echo "The program failed to compile. See error above"
    echo -e "\n"
    exit
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt
lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)

if [[ $lastline = *OK* ]]
then
    echo "Grade: 100%"
else
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes=$((tests - failures))
    echo "Grade: $successes / $tests"
fi

echo -e "\n"

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
