# Motivation
The idea of this project is to fit a log Gaussian Cox Process to the [Wildfires in Canada](https://www.kaggle.com/datasets/ulasozdemir/wildfires-in-canada-19502021) dataset. Since simulation and inference of point processes requires MCMC methods which can be computationally expensive I this will be done using INLA-SPDE approach(see [Lindgren, F., Rue, H. and Lindström, J. (2011)](https://rss.onlinelibrary.wiley.com/doi/10.1111/j.1467-9868.2011.00777.x)) which will be contrasted with a full MCMC version.
## Data Description
![](assets/plots/wildfires_5Y.png)

