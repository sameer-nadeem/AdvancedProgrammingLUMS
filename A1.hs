-- ---------------------------------------------------------------------
-- DNA Analysis
-- CS300 Spring 2021 Assignment 1
-- Deadline: 11pm on Tuesday 16 February
--
-- * Enable word-wrap by pressing Alt-Z in Visual Studio Code.
-- * Each part has a main function for testing that part.
-- * Make additional helper functions wherever you need them.
-- * Do not show your code or make it accessible to anyone other than the course staff.
-- * Replace 'undefined' with your own code when you are implementing a particular part.
-- * Do not change existing types of any functions.
-- ---------------------------------------------------------------------

-- DNA can be thought of as a sequence of nucleotides.  Each nucleotide is Adenine, Cytosine, Guanine, or Thymine. These are abbreviated as A, C, G, and T.  Similar organisms have similar DNA.  In this assignment, we will build an evolutionary tree of organisms where the leaf node represents real organisms and internal nodes join the most similar organisms and represent the overlapping part of their DNA.

import Control.Monad

-- PART 1
-- We want to calculate how alike are two DNA strands and will represent it with an integer score.  We will try to align the DNA strands.  An aligned nucleotide gets 4 points, a misaligned nucleotide gets 3 point, and inserting a gap in one of the strands gets 1 point.  Since we are not sure how the next two characters should be aligned, we need to try all three approaches and pick the one that gets us the maximum score.  You can use the builtin maximum function.

-- 1) Align or misalign the next nucleotide from both strands
-- 2) Align the next nucleotide from first strand with a gap in the second
-- 3) Align the next nucleotide from second strand with a gap in the first

score :: String -> String -> Int
score = \dna1 -> \dna2 ->
    case dna1 of
        "" -> case dna2 of
                "" -> 0
                y:ys -> 1 + score "" ys
        x:xs -> case dna2 of
                    "" -> 1 + score xs ""    
                    y:ys | y == x -> max (max (1 + score xs dna2) (1 + score dna1 ys)) (4 + score xs ys)
                    y:ys -> max (max (1 + score xs dna2) (1 + score dna1 ys)) (3 + score xs ys)
                    
--main = print (score "TCCG" "TCCG")
-- Expected output: 24

-- PART 2
-- We now want to calculate the best DNA overlap in the best alignment along with the score.  The DNA overlap will have nucleotides only where the aligned DNAs match while gaps and mismatches should be represented with "?".

alignment :: String -> String -> (Int, String)
alignment = \dna1 -> \dna2 ->
    case dna1 of
        "" -> case dna2 of
                "" -> (0, "")
                [y] -> (1, "1")
                y:ys -> case (alignment "" ys) of
                            (t,p) -> (1 + t, '2':p)
        x:xs -> case dna2 of
                    "" -> case (alignment xs "") of
                            (t,p) -> (1 + t, '3':p)
                    [y] -> (1, "")
                    y:ys | (score dna1 dna2) == (4 + score xs ys) -> case (alignment xs ys) of
                                                                        (t,p) -> (4 + t, 's':p)
                    y:ys | (score dna1 dna2) == (3 + score xs ys) ->  case (alignment xs ys) of
                                                                        (t,p) -> (3 + t, '4':p)
                    y:ys | (score dna1 dna2) == (1 + score dna1 ys) -> case (alignment dna1 ys) of
                                                                        (t,p) -> (1 + t, '5':p)
                    y:ys | (score dna1 dna2) == (1 + score xs dna2) -> case (alignment xs dna2) of
                                                                        (t,p) -> (1 + t, '6':p)


main = print (alignment "TCCG" "ATCCG")
-- Expected output: (24,"?T?TCCG")

-- PART 3
-- Make all possible pairs of elements in a given list

makePairs :: [] a -> [] (a, a)
makePairs = undefined

-- main = print (makePairs [1, 2, 3])
-- Expected Output: [(1,2),(1,3),(2,3)]

-- PART 4
-- Write a function to remove the first matching element in a given list

removeFirst :: Eq a => a -> [a] -> [a]
removeFirst = undefined

-- main = print (removeFirst 3 [1, 3, 2, 4, 3])
-- Expected Output: [1,2,4,3]

-- PART 5
-- Write a function to find the maximum element in a list based on the result of applying a given function on each element.  Note that the original element is returned and not the transformed element.

maxOn :: Ord b => (a -> b) -> [] a -> a
maxOn = undefined

-- main = print (maxOn abs [1, 3, -2, -4, 3])
-- Expected Output: -4

-- PART 6
-- Make the following tree an instance of Eq typeclass by defining the == function.

data Tree a = Nil | Node (Tree a) (Tree a) a

instance Eq a => Eq (Tree a) where
    (==) = undefined

-- main = print [Nil == Node Nil Nil 5, Node Nil Nil 5 == Node Nil Nil 5, Node Nil Nil 6 == Node Nil Nil 5]
-- Expected Output: [False,True,False]

-- PART 7
-- Make Tree an instance of Show typeclass by defining the show function that takes a Tree and returns a string.  The function should neatly print the tree, as shown in the example and expected output below.

instance Show a => Show (Tree a) where
    show = undefined

-- main = print (Node (Node (Node (Node Nil (Node Nil Nil 3) 2) (Node Nil Nil 5) 4) Nil 6) (Node Nil Nil 8) 7)
-- Expected Output:
-- 7
-- +---6
-- |   +---4
-- |   |   +---2
-- |   |   |   +---3
-- |   |   +---5
-- +---8

-- PART 8
-- Consider a tree containing a tuple of key-value pairs such that the tree is organized as a binary search tree based on the key value.  A binary search tree stores all keys less than the one in the root in the left sub-tree and the rest in the right subtree.  Write a function to insert new values in the tree according to the above constraint.  Remember that insertion means returning a new tree with the new element added, that you do not have to think how recursive call inserts in subtrees, and that you only really have to insert if the tree is Nil.

insert :: Ord a => Tree (a,b) -> (a,b) -> Tree (a,b)
insert = undefined

-- main = print (insert (insert (insert (insert Nil (7, "Seven")) (8, "Eight")) (6, "Six")) (5, "Five"))
-- Expected Output:
-- (7,"Seven")
-- +---(6,"Six")
-- |   +---(5,"Five")
-- +---(8,"Eight")

-- PART 9
-- Write a function to find values against a given key in the tree.  If the value is not found, return Nothing, otherwise return the value wrapped in Just.  Read about the Haskell Maybe data type.

contains :: Ord a => Tree (a,b) -> a -> Maybe b
contains = undefined

-- main = print (contains (insert (insert (insert (insert Nil (7, "Seven")) (8, "Eight")) (6, "Six")) (5, "Five")) 8)
-- Expected Output: Just "Eight"
-- main = print (contains (insert (insert (insert (insert Nil (7, "Seven")) (8, "Eight")) (6, "Six")) (5, "Five")) 9)
-- Expected Output: Nothing

-- PART 10
-- Write a function that take a list of Trees of DNA strings.  The function should replace the two closest trees (according to highest score of DNA strings in the root node) with a new Node having the the DNA intersection (calculated with alignment function) at the root and the two removed trees as children.  The returned list will have one less element than the input list.  Use the functions written in above parts.
evolStep :: [] (Tree String) -> [] (Tree String)
evolStep = undefined

-- main = print (evolStep [Node Nil Nil "AAATTT", Node Nil Nil "CCCTGGG", Node Nil Nil "ATTCCG", Node Nil Nil "TTATCCG"])
-- Expected Output:
-- ["?T?TCCG"
-- +---"ATTCCG"
-- +---"TTATCCG"
-- ,"AAATTT"
-- ,"CCCTGGG"
-- ]

-- PART 11
-- Write a function that converts a given list of DNAs to single Node DNA Trees and then repeatedly applies the above function to combine all DNA Trees into a single Tree.  This is the evolutionary tree we wanted.

makeEvolTree :: [] String -> Tree String
makeEvolTree = undefined

-- main = print (makeEvolTree ["AAATTT", "CCCTGGG", "ATTCCG", "TTATCCG"])
-- Expected Output:
-- "???T???"
-- +---"???T??G"
-- |   +---"?T?TCCG"
-- |   |   +---"ATTCCG"
-- |   |   +---"TTATCCG"
-- |   +---"CCCTGGG"
-- +---"AAATTT"

-- PART 12
-- Our score function is inefficient due to repeated calls for the same suffixes.  Lets make a dictionary to remember previous results.  We will use the Tree of tuples and insert/contains functions above as our dictionary.  An extra dictionary argument is added.  If the result is in dictionary, we should return from there, otherwise, we return the result in a tuple combined with the updated dictionary.  Remember that you need to pass the dictionary to recursive calls and pass the updated dictionary from the first recursive call to the second and so on.

scoreMemo :: (String, String) -> Tree ((String, String), Int) -> (Int, Tree ((String, String), Int))
scoreMemo = undefined

-- main = print (scoreMemo ("ATTCCG", "TTATCCG") Nil)
-- Expected output:
-- (24,(("G","G"),4)
-- +---(("G","CG"),5)
-- |   +---(("G","CCG"),6)
-- ... many more lines ...

-- PART 13
-- Lets capture the dictionary argument and return type in the new data type below.  Note that scoreMemo2 has one argument but it returns a WithMemoType result that hold a function which takes the dictionary argument and return the actual result with updated dictionary.  Every time you do a recursive call, you need to destructure WithMemoType and call the destructured function to actually get the result and updated dictionary.  Note that this part will be longer and with some repetition compared to the last part.

data WithMemoType a b = WithMemo (Tree a -> (b,Tree a))

scoreMemo2 :: (String, String) -> WithMemoType ((String, String), Int) Int
scoreMemo2 = \x ->
    WithMemo (\d ->
        undefined
    )

-- main = let WithMemo fn = scoreMemo2 ("ATTCCG", "TTATCCG") in print (fn Nil)
-- Expected output: same as last part

-- PART 14
-- We will now make (WithMemoType a) a Monad by defining a bind (>>=) function.  Ignore the Functor and Applicative definitions.  Next make a new version of scoreMemo where the three recursive calls are connected using the bind operator such that you destructure once instead of multiple times.  It is possible to avoid ever destructuring by making dictionary insertion and lookup monadic as well, but that is out of the scope of this assignment.

instance Functor (WithMemoType a) where
    fmap = liftM

instance Applicative (WithMemoType a) where
    pure = \x -> WithMemo (\d -> (x,d))
    (<*>) = ap

instance Monad (WithMemoType a) where
    (>>=) = undefined

scoreMemo3 :: (String, String) -> WithMemoType ((String, String), Int) Int
scoreMemo3 = undefined

-- main = let WithMemo fn = scoreMemo3 ("ATTCCG", "TTATCCG") in print (fn Nil)
-- Expected output: same as last part