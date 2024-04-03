from yelp_API import YelpScraper
from woof_API import WoofAPI


if __name__ == '__main__':
    api = WoofAPI()
    api.send_defaults()
    api.populate_random()
    # print(api.getInternalAccountNames())
    
    params = {
        'term': 'pet friendly',
        'location': 'Long Island',  # Specify the location you want to search in
        # 'categories': 'restaurants,bars,businesses,hotel,parks',  # Specify the category of businesses you want to search for
        'limit': 30  # Limit the number of results
    }
    businesses = YelpScraper("businesses", params).getData()
    reviews = YelpScraper("reviews", params).getData()
    
    