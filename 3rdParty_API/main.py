from yelp_API import YelpScraper


if __name__ == '__main__':
    params = {
        'term': 'pet friendly',
        'location': 'Long Island',  # Specify the location you want to search in
        'categories': 'restaurants,bars,businesses,hotel,parks',  # Specify the category of businesses you want to search for
        'limit': 10  # Limit the number of results
    }
    scrape = YelpScraper("events", params)
    scrape.getData()