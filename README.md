# MICE_R

This file runs through an example of multiple imputation using chained equations (MICE) and mediation analysis in R. The dataset (airquality) is already built into R. 

Multiple imputation is an extremely helpful and powerful tool when you have missing data. As a child development researcher, my data is particularly prone to missingness. Parents might not want to return to the lab, children get sleepy or fussy- it happens.

However, there are ways to successfully and accurately reduce errors and bias caused by missing data. I found an article by Enders (2012) by to be extremely helpful in explaining the benefits of imputation as opposed to case-wise deletion- which is the most common practice in developmental research. 

Before going forward, I used van Buuren's article to help me create the code, think about multiple imputation on a theoretical level, and also decide which parameters to use. I highly recommend you read through his article before pursuing multiple imputation!
 
For a recent project, I decided to use multiple imputation. I had rates of missingness ranging from 0% to 23%. Many sources (e.g., Little & Rubin, 2002; Bodner, 2008; White, Royston, & Wood, 2011) suggest creating as many datasets as the average rate of missing. So, in my case, I had an average of 10% missing, so I created 10 imputed datasets. 
 
**Note, if you want your results to be consistent (for sharing or publishing purposes, make sure to set your seed when imputing!)

Using 'mice' package in R was very easy, and I had little trouble generating imputed datasets or pooling them. I also found visualizing the imputed data and comparing it to the original data using the 'VIM' package to be helpful. Using 'mice' to run linear regression models was also fairly simple.

Where I ran into trouble was using 'mice' and 'lavaan' to run a mediation analysis using my imputed data sets. Here is how I solved it- I hope it helps!

See blog post [here](https://jessierayebauer.wixsite.com/jrbauer/single-post/2017/09/16/multipleimputationmediation)
See Jupyter notebook here
