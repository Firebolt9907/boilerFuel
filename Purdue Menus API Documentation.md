# Figuring out the Undocumented API

## Overview

This API provides access to the Purdue Dining court menus. It allows us to grab the ingredients and allergens for each food item. We used inspect element to extract the api endpoints from the Purdue Menus website, so we can implement it without web scraping. 

## Full Menu

```GET

https://api.hfs.purdue.edu/menus/v2/locations/[Dining Court Name]/[Today's date in the format MM-DD-YYYY]

// Example:
https://api.hfs.purdue.edu/menus/v2/locations/Wiley/09-20-2025
```

This will return a list of every single food item served at the dining court for all three meals that day in the JSON format. An example is shown below:

```json
{
	"Location":"Wiley",
	"Date":"9/20/2025",
	[...]
	"Meals":[
	    {
		  "ID": "1601a1d5-3853-447d-9ea7-00ae657dd887",
		  "Name": "Breakfast",
		  "Order": 0,
		  "Status": "Closed",
		  "Type": "Breakfast",
		  "Hours": null,
		  "Notes": null,
		  "Stations": []
		},
		{
			"ID":"1e7690ec-b4c9-42f1-9cc7-fa591039b471",
			"Name":"Lunch",
			[...]
			"Hours":{"StartTime": "11:00:00","EndTime": "14:00:00"},
			[...]
			"Stations":[
				[...],
				{
					"Name":"La Fonda",
					"Items":[
						{
							"ID":"bc188827-5f12-450a-83d2-8c8890cc6c0c",
							"Name": "Chorichicken Strips",
							"IsVegetarian": false,
							"NutritionReady": true,
							"Allergens":[
								{"Name":"Coconut","Value":false},
								{"Name":"Eggs","Value":false},
								{"Name":"Fish","Value":false},
								[...]
							]
						},
						[...]
					]
				},
				[...]
			]
		},
		{
			[...]
			"Name":"Dinner",
			[...]
		}
	]
}
```

If you look closely, you will notice that they list out every single allergen for every single menu item, matched with a boolean, so we could use that for simple dietary restrictions like having nut allergies (like Jeffrey). However, it doesn't list out every single ingredient, so we need to make additional requests for lesser known diets like Rishu's (no beef or pork).
## More info for one food item

Luckily, the official website allows us to see the ingredients that went into some food, and it calls this api in the background:

```POST
https://api.hfs.purdue.edu/menus/v3/GraphQL
```

with the body:

```JSON
{
	"variables":
	{"id":"bc188827-5f12-450a-83d2-8c8890cc6c0c"},
	"query":"query ($id: Guid!) {\n  itemByItemId(itemId: $id) {\n    itemId\n    name\n    ingredients\n    isNutritionReady\n    nutritionFacts {\n      dailyValueLabel\n      label\n      name\n      value\n      __typename\n    }\n    traits {\n      svgIcon\n      svgIconWithoutBackground\n      name\n      type\n      __typename\n    }\n    appearances {\n      date\n      locationName\n      stationName\n      mealName\n      __typename\n    }\n    components {\n      itemId\n      name\n      isFlaggedForCurrentUser\n      isHiddenForCurrentUser\n      isNutritionReady\n      traits {\n        svgIcon\n        svgIconWithoutBackground\n        name\n        type\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}"
}
```

~~As far as we know, most of those arguments aren't needed, but we don't want to touch what works and waste time in a hackathon.~~ After testing it, we found out that the long list of arguments are actually telling the server what to return, and we can remove unnecessary calls to make the data less complex. Calling this api would return the following:

```json
{
  "data": {
    "itemByItemId": {
      "itemId": "bc188827-5f12-450a-83d2-8c8890cc6c0c",
      "name": "Chorichicken Strips",
      "ingredients": "Chicken Fajita Strip (Chicken Breast Meat With Rib Meat, Water, Salt, Spices, Sodium Phosphate, [...]",
      "isNutritionReady": true,
      "nutritionFacts": [
        {
          "dailyValueLabel": null,
          "label": "1 Cup Serving",
          "name": "Serving Size",
          "value": null,
          "__typename": "NutritionFact"
        },
        {
          "dailyValueLabel": null,
          "label": "298",
          "name": "Calories",
          "value": 297.8169,
          "__typename": "NutritionFact"
        },
        [...],
        {
          "dailyValueLabel": "6%",
          "label": null,
          "name": "Iron",
          "value": 0.9774,
          "__typename": "NutritionFact"
        }
      ],
      "traits": [
	    [Info for image of allergens],
      ],
      "appearances": [
        {
          "date": "2025-09-20T11:00:00-04:00",
          "locationName": "Wiley",
          "stationName": "La Fonda",
          "mealName": "Lunch",
          "__typename": "ItemOccurrence"
        },
        {
          "date": "2025-09-20T17:00:00-04:00",
          "locationName": "Wiley",
          "stationName": "La Fonda",
          "mealName": "Dinner",
          "__typename": "ItemOccurrence"
        }
      ],
      "components": null,
      "__typename": "Item"
    }
  }
}
```

~~Something interesting I found when looking at some items is that it can show the appearances of an item up to a few days in the future, **even at other dining courts**. It remains to be seen as to how we can make a POST request to the v3 api inside flutter, especially since its very unlikely that we can generate a cookie inside an app. A possibility to bypass that might be to generate many different cookies on a computer by clearing cookies, copying down every cookie generated, and randomly choose from those to reduce the likelihood of rate limiting issues.~~
Update after the hackathon: No cookies were needed to make this work, and we just ended up making a copy on our own server that UPlate makes requests to. 
