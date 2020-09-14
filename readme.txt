Hello! 

For my SidelineSwap coding evaluation, I created "GearSwap."

As the prompt asks, GearSwap contains a search bar docked to the top of the screen and a UICollectionView 
on its main screen, the SearchViewController. When a user searches for an item, the app sends a request to 
the SidelineSwap API. If the request response contains valid results, the screen will be populated with 
collection view cells. Each cell represents an item from the response and contains the item's primary image,
its name, seller, and price. If the request fails or returns unexpected data, the user is prompted with an
UIAlertController.

The search can be refired by pulling down from the top of the collection view. If the search request provides
more pages of results, a succeeding request for the next page of results is fired if the user scrolls towards
the bottom of the collection view. 

For the app's architecture, I used a mix of MVP and MVVM. The SearchPresenter handles the main search request 
and also creates view models, the ItemViewModel, for the SearchViewController to display. 

To handle image caching, I created the ImageCache class, which uses a NSCache with a URL key and UIImage
value pair. The ImageHelper struct has an instance of the ImageCache class. The ImageHelper makes a network 
request for the image data if the cache does not already contain the URL key. If the cache already contains 
the URL key, the ImageHelper will return a UIImage from the cache. 

I created a unit test suite which Xcode determined covers 92.5% of the app's code. The unit tests can be run 
from the "GearSwapUnitTests" scheme.

Thank you for your time and consideration. I look forward to discussing my app further with you folks!

Regards,
Kevin