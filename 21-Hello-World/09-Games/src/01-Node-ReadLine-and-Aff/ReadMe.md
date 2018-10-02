# Node ReadLine and Aff

To use receive input from a user via the terminal, we need to use `Node.ReadLine`'s API. However, using the `Effect` monad for this will not work as expected. Thus, we will be forced to use `Aff`.

In this folder, we'll cover more of `Aff` in the context of `Node.ReadLine` but we will not cover both in all of their complexity. For a deeper explanation of `Aff`, see [this video](https://www.youtube.com/watch?v=dbM72ap30TE&index=20&t=0s&list=WL)
