from yelp_API import YelpScraper
from woof_API import WoofAPI


if __name__ == '__main__':
    # params = {
    #     'term': 'pet friendly',
    #     'location': 'Long Island',  # Specify the location you want to search in
    #     'categories': 'restaurants,bars,businesses,hotel,parks',  # Specify the category of businesses you want to search for
    #     'limit': 10  # Limit the number of results
    # }
    # scraper = YelpScraper("businesses", params)
    # businesses = scraper.getData()
    # for business in businesses:
    #     print(business)
    api = WoofAPI()
    print(api.getBusinesses())