// 1. Print only the names, surnames and ages of all hosts.
db.lodging.aggregate([
  {
      $project:
        {
          _id: 0,
          name: "$host.name",
          surname: "$host.surname",
          age: "$host.age"
        }
    }
]);

// 2. Print a list of all the accommodations sorted first by price, and then by the number of amenities they offer.
db.lodging.aggregate(
  [
    {
      $addFields:
        {
          "lodging.numericPrice": {
            $toInt: {
              $substr: ["$lodging.price", 1, -1]
            }
          },
          "lodging.numberOfAmenities": {
            $size: {
              $objectToArray: "$lodging.amenities"
            }
          }
        }
    },
    {
      $sort:
        {
          "lodging.numericPrice": 1,
          "lodging.numberOfAmenities": 1
        }
    }
  ]
);

// 3. Count and sort the number of accommodations in every state, taking into account only active hosts that registered before March 2013.
db.lodging.aggregate(
  [
    {
      $addFields:
        {
          registeredDate: {
            $convert: {
              input: "$registered",
              to: "date"
            }
          }
        }
    },
    {
      $match:
        {
          isActive: true,
          registeredDate: {
            $lt: ISODate("2013-03-01")
          }
        }
    },
    {
      $group:
        {
          _id: "$lodging.address.state",
          numberOfAccommodations: {
            $sum: 1
          }
        }
    },
    {
      $sort:
        {
          numberOfAccommodations: 1
        }
    }
  ]
);

// 4. For each accommodation, print out every third and any further review received by the lodging. If she has only received two critics or fewer, please print out all the reviews she received.
db.lodging.aggregate(
  [
    {
      $addFields:
        {
          "lodging.reviewCount": {
            $size: "$lodging.reviews"
          }
        }
    },
    {
      $project:
        {
          "lodging.reviewCount": 1,
          reviewsPreview: {
            $cond: {
              if: {
                $lte: ["$lodging.reviewCount", 2]
              },
              then: "$lodging.reviews",
              else: {
                $slice: [
                  "$lodging.reviews",
                  2,
                  {
                    $size: "$lodging.reviews"
                  }
                ]
              }
            }
          }
        }
    }
  ]
);

// 5. Print all the combinations of points that were assigned to the accommodations and sort them by the number of accommodations that received these points.
db.lodging.aggregate(
  [
    {
      $unwind:
        {
          path: "$lodging.reviews"
        }
    },
    {
      $group:
        {
          _id: {
            cleanliness: "$lodging.reviews.cleanliness",
            location: "$lodging.reviews.location",
            food: "$lodging.reviews.food"
          },
          accommodationCount: {
            $sum: 1
          }
        }
    },
    {
      $sort:
        {
          accommodationCount: -1
        }
    }
  ]
);

// 6. Print a list of all accommodations from the state of Ohio, where the host speaks English or the accommodation has an average score of over 7.5.
db.lodging.aggregate(
  [
    {
      $addFields:
        {
          averageLodgingScore: {
            $avg: {
              $map: {
                input: "$lodging.reviews",
                as: "review",
                in: {
                  $avg: [
                    "$$review.cleanliness",
                    "$$review.location",
                    "$$review.food"
                  ]
                }
              }
            }
          }
        }
    },
    {
      $match:
        {
          "lodging.address.state": "Ohio",
          $or: [
            {
              "host.languages": "english"
            },
            {
              averageLodgingScore: {
                $gt: 7.5
              }
            }
          ]
        }
    }
  ]
);