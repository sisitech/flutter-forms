const studentsOptions = {
  "name": "List Create Students Api",
  "description": "",
  "renders": ["application/json", "text/html"],
  "parses": [
    "application/json",
    "application/x-www-form-urlencoded",
    "multipart/form-data"
  ],
  "actions": {
    "POST": {
      "id": {
        "type": "integer",
        "required": false,
        "read_only": true,
        "label": "ID"
      },
      "school_name": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "School name"
      },
      "stream_name": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Stream name"
      },
      "base_class": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Base class"
      },
      "full_name": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Full name"
      },
      "student_id": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Student id"
      },
      "date_enrolled": {
        "type": "date",
        "required": true,
        "read_only": false,
        "label": "Date Enrolled"
      },
      "special_needs_details": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Special needs details",
        "child": {
          "type": "nested object",
          "required": false,
          "read_only": true,
          "children": {
            "id": {
              "type": "integer",
              "required": false,
              "read_only": true,
              "label": "ID"
            },
            "created": {
              "type": "datetime",
              "required": false,
              "read_only": true,
              "label": "Created"
            },
            "modified": {
              "type": "datetime",
              "required": false,
              "read_only": true,
              "label": "Modified"
            },
            "name": {
              "type": "string",
              "required": true,
              "read_only": false,
              "label": "Name",
              "max_length": 100
            },
            "abbreviation": {
              "type": "string",
              "required": false,
              "read_only": false,
              "label": "Abbreviation",
              "max_length": 10
            }
          }
        }
      },
      "county": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "County"
      },
      "guardian_county": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Guardian county"
      },
      "age": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Age"
      },
      "status_display": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Status display"
      },
      "gender_display": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Gender display"
      },
      "region_name": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Region name"
      },
      "district_name": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "District name"
      },
      "shehiya_name": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Shehiya name"
      },
      "guardian_region_name": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Guardian region name"
      },
      "guardian_district_name": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Guardian district name"
      },
      "guardian_shehiya_name": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Guardian shehiya name"
      },
      "guardian_status_display": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Guardian status display"
      },
      "created": {
        "type": "datetime",
        "required": false,
        "read_only": true,
        "label": "Created"
      },
      "modified": {
        "type": "datetime",
        "required": false,
        "read_only": true,
        "label": "Modified"
      },
      "emis_code": {
        "type": "integer",
        "required": false,
        "read_only": false,
        "label": "Emis code"
      },
      "first_name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "First Name",
        "max_length": 200
      },
      "middle_name": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Middle Name",
        "max_length": 200
      },
      "last_name": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Last Name",
        "max_length": 200
      },
      "date_of_birth": {
        "type": "date",
        "required": true,
        "read_only": false,
        "label": "Date Of Birth"
      },
      "admission_no": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Admission Number",
        "max_length": 50
      },
      "gender": {
        "type": "choice",
        "required": true,
        "read_only": false,
        "label": "Gender",
        "choices": [
          {"value": "M", "display_name": "MALE"},
          {"value": "F", "display_name": "FEMALE"}
        ]
      },
      "previous_class": {
        "type": "integer",
        "required": false,
        "read_only": false,
        "label": "Previous class",
        "min_value": -2147483648,
        "max_value": 2147483647
      },
      "mode_of_transport": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Mode of transport",
        "choices": [
          {"value": "PERSONAL", "display_name": "Personal Vehicle"},
          {"value": "BUS", "display_name": "School Bus"},
          {"value": "FOOT", "display_name": "By Foot"},
          {"value": "NS", "display_name": "Not Set"}
        ]
      },
      "time_to_school": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Time to school",
        "choices": [
          {"value": "1HR", "display_name": "One Hour"},
          {"value": "-0.5HR", "display_name": "Less than 1/2 Hour"},
          {"value": "+1HR", "display_name": "More than one hour."},
          {"value": "NS", "display_name": "Not Set"}
        ]
      },
      "distance_from_school": {
        "type": "integer",
        "required": false,
        "read_only": false,
        "label": "Distance from School",
        "min_value": -2147483648,
        "max_value": 2147483647
      },
      "household": {
        "type": "integer",
        "required": false,
        "read_only": false,
        "label": "Household",
        "min_value": -2147483648,
        "max_value": 2147483647
      },
      "meals_per_day": {
        "type": "integer",
        "required": false,
        "read_only": false,
        "label": "Meals per day",
        "min_value": -2147483648,
        "max_value": 2147483647
      },
      "not_in_school_before": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Not in school before"
      },
      "emis_code_histories": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Emis code histories",
        "max_length": 200
      },
      "total_attendance": {
        "type": "integer",
        "required": false,
        "read_only": false,
        "label": "Total attendance",
        "min_value": -2147483648,
        "max_value": 2147483647
      },
      "total_absents": {
        "type": "integer",
        "required": false,
        "read_only": false,
        "label": "Total absents",
        "min_value": -2147483648,
        "max_value": 2147483647
      },
      "last_attendance": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Last attendance"
      },
      "knows_dob": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Knows dob"
      },
      "father_name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Father's Name",
        "max_length": 50
      },
      "mother_name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Mother's Name",
        "max_length": 50
      },
      "father_phone": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Father's Phone Number",
        "max_length": 20
      },
      "mother_phone": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Mother's Phone Number",
        "max_length": 20
      },
      "father_status": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Father's Status",
        "choices": [
          {"value": "A", "display_name": "Alive"},
          {"value": "D", "display_name": "Deceased"},
        ]
      },
      "mother_status": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Mother's Status",
        "choices": [
          {"value": "A", "display_name": "Alive"},
          {"value": "D", "display_name": "Deceased"},
        ]
      },
      "live_with_parent": {
        "type": "field",
        "required": true,
        "read_only": false,
        "default": true,
        "label": "Do You Live With any of your Parent?",
        "choices": [
          {"value": true, "display_name": "Yes"},
          {"value": false, "display_name": "No"},
        ]
      },
      "guardian_name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Guardian Name",
        "max_length": 50,
        "from_field": "live_with_parent",
        "show_only": false
      },
      "guardian_phone": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Guardian Phone",
        "max_length": 20,
        "from_field": "live_with_parent",
        "show_only": false
      },
      "guardian_relationship": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Guardian Relationship",
        "max_length": 30,
        "from_field": "live_with_parent",
        "show_only": false
      },
      "guardian_status": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Guardian Status",
        "from_field": "live_with_parent",
        "show_only": false,
        "choices": [
          {"value": "B", "display_name": "Both Parents"},
          {"value": "S", "display_name": "Single Parent"},
          {"value": "N", "display_name": "None"},
          {"value": "NS", "display_name": "Not Set"}
        ]
      },
      "region": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Region",
        "display_name": "name",
        "storage": "regions",
      },
      "district": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "District",
        "display_name": "name",
        "storage": "regions",
        "from_field": "region",
        "search_field": "id"
      },
      "shehiya": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Shehiya",
        "display_name": "name",
        "storage": "districts",
        "from_field": "district",
        "search_field": "id",
        "from_field_source": "shehiyas_details",
      },
      "street_name": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Street Name",
        "max_length": 50
      },
      "house_number": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "House Number",
        "max_length": 50
      },
      "guardian_region": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Guardian Region",
        "display_name": "name",
        "storage": "regions",
      },
      "guardian_district": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Guardian District",
        "display_name": "name",
        "storage": "regions",
        "from_field": "guardian_region",
        "from_field_source": "districts_details",
      },
      "guardian_shehiya": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Guardian Shehiya",
        "display_name": "name",
        "storage": "districts",
        "from_field": "guardian_district",
        "from_field_source": "shehiyas_details",
      },
      "active": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Active"
      },
      "graduated": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Graduated"
      },
      "dropout_reason": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Dropout reason",
        "max_length": 200
      },
      "offline_id": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Offline id",
        "max_length": 20
      },
      "status": {
        "type": "choice",
        "required": true,
        "read_only": false,
        "label": "Student Status",
        "choices": [
          {"value": "OOSC", "display_name": "Over Age"},
          {"value": "NE", "display_name": "Never Enrolled"},
          {"value": "PE", "display_name": "Re Enrolled"}
        ]
      },
      "moe_id": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Moe id",
        "max_length": 50
      },
      "moe_unique_id": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Moe unique id",
        "max_length": 45
      },
      "moe_extra_info": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Moe extra info"
      },
      "has_attended_pre_primary": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Has attended Pre-Primary?",
        "choices": [
          {"value": true, "display_name": "Yes"},
          {"value": false, "display_name": "No"},
        ]
      },
      "upi": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Upi",
        "help_text": "Unique Identification provided by the school",
        "max_length": 45
      },
      "stream": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Class",
        "storage": "classes",
        "display_name": "class_name"
      },
      "graduates_class": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Graduates class"
      },
      "has_special_needs": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Does the Learner have any Special Needs?",
        "choices": [
          {"value": true, "display_name": "Yes"},
          {"value": false, "display_name": "No"},
        ]
      },
      "special_needs": {
        "type": "multifield",
        "required": false,
        "read_only": false,
        "multiple": true,
        "label": "Select Learner Special Needs",
        "display_name": "name",
        "storage": "regions",
        // "from_field": "has_special_needs",
        // "show_only": true
      }
    }
  }
};

const studInstance = {
  "id": 2,
  "school_name": "Micha Primary School",
  "stream_name": "A",
  "class_name": "Mbadala A",
  "base_class": "0",
  "full_name": "Mwangi M Mia",
  "student_id": "435435",
  "date_enrolled": "2023-01-01",
  "special_needs_details": [],
  "region": 1,
  "district": 1,
  "status_display": "Never Enrolled",
  "gender_display": "FEMALE",
  "region_name": "Mjini Magharibi",
  "district_name": "Mjini",
  "shehiya_name": "Shangani",
  "current_guardian_name": null,
  "current_guardian_phone": null,
  "father_status_display": null,
  "mother_status_display": null,
  "guardian_region_name": "Mjini Magharibi",
  "guardian_district_name": "Mjini",
  "guardian_shehiya_name": "Shangani",
  "guardian_status_display": "Not Set",
  "guardian_region": 1,
  "guardian_district": 1,
  "created": "2022-08-06T19:14:11.971097+03:00",
  "modified": "2023-02-06T13:19:59.108372+03:00",
  "emis_code": null,
  "first_name": "Mwangi",
  "middle_name": "M",
  "last_name": "Mia",
  "date_of_birth": "2022-11-01",
  "admission_no": "435435",
  "gender": "F",
  "previous_class": 0,
  "mode_of_transport": "NS",
  "time_to_school": "NS",
  "distance_from_school": null,
  "household": 0,
  "meals_per_day": 0,
  "not_in_school_before": false,
  "emis_code_histories": null,
  "total_attendance": 0,
  "total_absents": 0,
  "last_attendance": null,
  "knows_dob": true,
  "father_name": null,
  "father_phone": null,
  "father_status": null,
  "mother_name": null,
  "mother_phone": null,
  "mother_status": null,
  "live_with_parent": false,
  "guardian_name": null,
  "guardian_phone": null,
  "guardian_status": "NS",
  "guardian_relationship": null,
  "has_special_needs": false,
  "active": true,
  "graduated": false,
  "dropout_reason": null,
  "offline_id": null,
  "status": "NE",
  "moe_id": null,
  "moe_unique_id": null,
  "moe_extra_info": null,
  "has_attended_pre_primary": true,
  "house_number": null,
  "street_name": null,
  "upi": null,
  "stream": 13,
  "shehiya": 1,
  "guardian_shehiya": 1,
  "graduates_class": null,
  "special_needs": []
};
