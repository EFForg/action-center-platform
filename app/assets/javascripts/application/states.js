var STATES = {
  ABBREV: [{
    name: 'ALABAMA',
    value: 'AL'
  }, {
    name: 'ALASKA',
    value: 'AK'
  }, {
    name: 'AMERICAN SAMOA',
    value: 'AS'
  }, {
    name: 'ARIZONA',
    value: 'AZ'
  }, {
    name: 'ARKANSAS',
    value: 'AR'
  }, {
    name: 'CALIFORNIA',
    value: 'CA'
  }, {
    name: 'COLORADO',
    value: 'CO'
  }, {
    name: 'CONNECTICUT',
    value: 'CT'
  }, {
    name: 'DELAWARE',
    value: 'DE'
  }, {
    name: 'DISTRICT OF COLUMBIA',
    value: 'DC'
  }, {
    name: 'FEDERATED STATES OF MICRONESIA',
    value: 'FM'
  }, {
    name: 'FLORIDA',
    value: 'FL'
  }, {
    name: 'GEORGIA',
    value: 'GA'
  }, {
    name: 'GUAM',
    value: 'GU'
  }, {
    name: 'HAWAII',
    value: 'HI'
  }, {
    name: 'IDAHO',
    value: 'ID'
  }, {
    name: 'ILLINOIS',
    value: 'IL'
  }, {
    name: 'INDIANA',
    value: 'IN'
  }, {
    name: 'IOWA',
    value: 'IA'
  }, {
    name: 'KANSAS',
    value: 'KS'
  }, {
    name: 'KENTUCKY',
    value: 'KY'
  }, {
    name: 'LOUISIANA',
    value: 'LA'
  }, {
    name: 'MAINE',
    value: 'ME'
  }, {
    name: 'MARSHALL ISLANDS',
    value: 'MH'
  }, {
    name: 'MARYLAND',
    value: 'MD'
  }, {
    name: 'MASSACHUSETTS',
    value: 'MA'
  }, {
    name: 'MICHIGAN',
    value: 'MI'
  }, {
    name: 'MINNESOTA',
    value: 'MN'
  }, {
    name: 'MISSISSIPPI',
    value: 'MS'
  }, {
    name: 'MISSOURI',
    value: 'MO'
  }, {
    name: 'MONTANA',
    value: 'MT'
  }, {
    name: 'NEBRASKA',
    value: 'NE'
  }, {
    name: 'NEVADA',
    value: 'NV'
  }, {
    name: 'NEW HAMPSHIRE',
    value: 'NH'
  }, {
    name: 'NEW JERSEY',
    value: 'NJ'
  }, {
    name: 'NEW MEXICO',
    value: 'NM'
  }, {
    name: 'NEW YORK',
    value: 'NY'
  }, {
    name: 'NORTH CAROLINA',
    value: 'NC'
  }, {
    name: 'NORTH DAKOTA',
    value: 'ND'
  }, {
    name: 'NORTHERN MARIANA ISLANDS',
    value: 'MP'
  }, {
    name: 'OHIO',
    value: 'OH'
  }, {
    name: 'OKLAHOMA',
    value: 'OK'
  }, {
    name: 'OREGON',
    value: 'OR'
  }, {
    name: 'PALAU',
    value: 'PW'
  }, {
    name: 'PENNSYLVANIA',
    value: 'PA'
  }, {
    name: 'PUERTO RICO',
    value: 'PR'
  }, {
    name: 'RHODE ISLAND',
    value: 'RI'
  }, {
    name: 'SOUTH CAROLINA',
    value: 'SC'
  }, {
    name: 'SOUTH DAKOTA',
    value: 'SD'
  }, {
    name: 'TENNESSEE',
    value: 'TN'
  }, {
    name: 'TEXAS',
    value: 'TX'
  }, {
    name: 'UTAH',
    value: 'UT'
  }, {
    name: 'VERMONT',
    value: 'VT'
  }, {
    name: 'VIRGIN ISLANDS',
    value: 'VI'
  }, {
    name: 'VIRGINIA',
    value: 'VA'
  }, {
    name: 'WASHINGTON',
    value: 'WA'
  }, {
    name: 'WEST VIRGINIA',
    value: 'WV'
  }, {
    name: 'WISCONSIN',
    value: 'WI'
  }, {
    name: 'WYOMING',
    value: 'WY'
  }],
  FULL: [{
    name: 'ALABAMA',
    value: 'Alabama'
  }, {
    name: 'ALASKA',
    value: 'Alaska'
  }, {
    name: 'AMERICAN SAMOA',
    value: 'American Samoa'
  }, {
    name: 'ARIZONA',
    value: 'Arizona'
  }, {
    name: 'ARKANSAS',
    value: 'Arkansas'
  }, {
    name: 'CALIFORNIA',
    value: 'California'
  }, {
    name: 'COLORADO',
    value: 'Colorado'
  }, {
    name: 'CONNECTICUT',
    value: 'Connecticut'
  }, {
    name: 'DELAWARE',
    value: 'Delaware'
  }, {
    name: 'DISTRICT OF COLUMBIA',
    value: 'District of Columbia'
  }, {
    name: 'FEDERATED STATES OF MICRONESIA',
    value: 'Federated States of Micronesia'
  }, {
    name: 'FLORIDA',
    value: 'Florida'
  }, {
    name: 'GEORGIA',
    value: 'Georgia'
  }, {
    name: 'GUAM',
    value: 'Guam'
  }, {
    name: 'HAWAII',
    value: 'Hawaii'
  }, {
    name: 'IDAHO',
    value: 'Idaho'
  }, {
    name: 'ILLINOIS',
    value: 'Illinois'
  }, {
    name: 'INDIANA',
    value: 'Indiana'
  }, {
    name: 'IOWA',
    value: 'Iowa'
  }, {
    name: 'KANSAS',
    value: 'Kansas'
  }, {
    name: 'KENTUCKY',
    value: 'Kentucky'
  }, {
    name: 'LOUISIANA',
    value: 'Louisiana'
  }, {
    name: 'MAINE',
    value: 'Maine'
  }, {
    name: 'MARSHALL ISLANDS',
    value: 'Marshall Islands'
  }, {
    name: 'MARYLAND',
    value: 'Maryland'
  }, {
    name: 'MASSACHUSETTS',
    value: 'Massachusetts'
  }, {
    name: 'MICHIGAN',
    value: 'Michigan'
  }, {
    name: 'MINNESOTA',
    value: 'Minnesota'
  }, {
    name: 'MISSISSIPPI',
    value: 'Mississippi'
  }, {
    name: 'MISSOURI',
    value: 'Missouri'
  }, {
    name: 'MONTANA',
    value: 'Montana'
  }, {
    name: 'NEBRASKA',
    value: 'Nebraska'
  }, {
    name: 'NEVADA',
    value: 'Nevada'
  }, {
    name: 'NEW HAMPSHIRE',
    value: 'New Hampshire'
  }, {
    name: 'NEW JERSEY',
    value: 'New Jersey'
  }, {
    name: 'NEW MEXICO',
    value: 'New Mexico'
  }, {
    name: 'NEW YORK',
    value: 'New York'
  }, {
    name: 'NORTH CAROLINA',
    value: 'North Carolina'
  }, {
    name: 'NORTH DAKOTA',
    value: 'North Dakota'
  }, {
    name: 'NORTHERN MARIANA ISLANDS',
    value: 'Northern Mariana Islands'
  }, {
    name: 'OHIO',
    value: 'Ohio'
  }, {
    name: 'OKLAHOMA',
    value: 'Oklahoma'
  }, {
    name: 'OREGON',
    value: 'Oregon'
  }, {
    name: 'PALAU',
    value: 'Palau'
  }, {
    name: 'PENNSYLVANIA',
    value: 'Pennsylvania'
  }, {
    name: 'PUERTO RICO',
    value: 'Puerto Rico'
  }, {
    name: 'RHODE ISLAND',
    value: 'Rhode Island'
  }, {
    name: 'SOUTH CAROLINA',
    value: 'South Carolina'
  }, {
    name: 'SOUTH DAKOTA',
    value: 'South Dakota'
  }, {
    name: 'TENNESSEE',
    value: 'Tennessee'
  }, {
    name: 'TEXAS',
    value: 'Texas'
  }, {
    name: 'UTAH',
    value: 'Utah'
  }, {
    name: 'VERMONT',
    value: 'Vermont'
  }, {
    name: 'VIRGIN ISLANDS',
    value: 'Virgin Islands'
  }, {
    name: 'VIRGINIA',
    value: 'Virginia'
  }, {
    name: 'WASHINGTON',
    value: 'Washington'
  }, {
    name: 'WEST VIRGINIA',
    value: 'West Virginia'
  }, {
    name: 'WISCONSIN',
    value: 'Wisconsin'
  }, {
    name: 'WYOMING',
    value: 'Wyoming'
  }]
};
