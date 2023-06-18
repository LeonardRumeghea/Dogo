# Diff Details

Date : 2023-06-17 19:02:27

Directory d:\\Documents\\GitHub\\Dogo\\dogo_front\\lib

Total : 40 files,  5445 codes, -26 comments, 599 blanks, all 6018 lines

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/Helpers/constants.dart](/lib/Helpers/constants.dart) | Dart | 14 | 5 | 5 | 24 |
| [lib/Helpers/fetches.dart](/lib/Helpers/fetches.dart) | Dart | 73 | 0 | 22 | 95 |
| [lib/Helpers/location_picker.dart](/lib/Helpers/location_picker.dart) | Dart | -224 | -6 | -33 | -263 |
| [lib/Helpers/pets.dart](/lib/Helpers/pets.dart) | Dart | 28 | 0 | 11 | 39 |
| [lib/Helpers/puts.dart](/lib/Helpers/puts.dart) | Dart | 62 | 0 | 23 | 85 |
| [lib/Helpers/screens/location_picker.dart](/lib/Helpers/screens/location_picker.dart) | Dart | 234 | 8 | 36 | 278 |
| [lib/Helpers/screens/path_current_location.dart](/lib/Helpers/screens/path_current_location.dart) | Dart | 456 | 15 | 69 | 540 |
| [lib/Helpers/screens/pet_profile.dart](/lib/Helpers/screens/pet_profile.dart) | Dart | 235 | 0 | 17 | 252 |
| [lib/Helpers/screens/view_location.dart](/lib/Helpers/screens/view_location.dart) | Dart | 369 | 4 | 55 | 428 |
| [lib/authentication/login_screen.dart](/lib/authentication/login_screen.dart) | Dart | 182 | 4 | 25 | 211 |
| [lib/authentication/register_screen.dart](/lib/authentication/register_screen.dart) | Dart | 119 | 0 | 10 | 129 |
| [lib/entities/address.dart](/lib/entities/address.dart) | Dart | 19 | 0 | 1 | 20 |
| [lib/entities/appointment.dart](/lib/entities/appointment.dart) | Dart | 67 | 11 | 20 | 98 |
| [lib/entities/person.dart](/lib/entities/person.dart) | Dart | 14 | 0 | 2 | 16 |
| [lib/entities/pet.dart](/lib/entities/pet.dart) | Dart | 10 | 0 | 0 | 10 |
| [lib/entities/preferences.dart](/lib/entities/preferences.dart) | Dart | 86 | 2 | 11 | 99 |
| [lib/home/services.dart](/lib/home/services.dart) | Dart | -280 | -85 | 3 | -362 |
| [lib/home/services/Walker/agenda.dart](/lib/home/services/Walker/agenda.dart) | Dart | -24 | 0 | -4 | -28 |
| [lib/home/services/Walker/preferences.dart](/lib/home/services/Walker/preferences.dart) | Dart | -24 | 0 | -4 | -28 |
| [lib/home/services/Walker/search.dart](/lib/home/services/Walker/search.dart) | Dart | -24 | 0 | -4 | -28 |
| [lib/home/services/owner_screens/appointments.dart](/lib/home/services/owner_screens/appointments.dart) | Dart | 101 | 0 | 9 | 110 |
| [lib/home/services/owner_screens/history.dart](/lib/home/services/owner_screens/history.dart) | Dart | 27 | 0 | 6 | 33 |
| [lib/home/services/owner_screens/pets/create_pet.dart](/lib/home/services/owner_screens/pets/create_pet.dart) | Dart | 470 | 1 | 43 | 514 |
| [lib/home/services/owner_screens/pets/pets.dart](/lib/home/services/owner_screens/pets/pets.dart) | Dart | 86 | 8 | 7 | 101 |
| [lib/home/services/owner_screens/pets/update_or_create_pet.dart](/lib/home/services/owner_screens/pets/update_or_create_pet.dart) | Dart | -484 | -1 | -37 | -522 |
| [lib/home/services/owner_screens/pets/update_pet.dart](/lib/home/services/owner_screens/pets/update_pet.dart) | Dart | 516 | 1 | 46 | 563 |
| [lib/home/services/owner_screens/schedules/schedule_salon.dart](/lib/home/services/owner_screens/schedules/schedule_salon.dart) | Dart | 35 | 0 | 8 | 43 |
| [lib/home/services/owner_screens/schedules/schedule_shopping.dart](/lib/home/services/owner_screens/schedules/schedule_shopping.dart) | Dart | 20 | -2 | 5 | 23 |
| [lib/home/services/owner_screens/schedules/schedule_sitting.dart](/lib/home/services/owner_screens/schedules/schedule_sitting.dart) | Dart | 57 | 0 | 8 | 65 |
| [lib/home/services/owner_screens/schedules/schedule_vet.dart](/lib/home/services/owner_screens/schedules/schedule_vet.dart) | Dart | 47 | 0 | 9 | 56 |
| [lib/home/services/owner_screens/schedules/schedule_walk.dart](/lib/home/services/owner_screens/schedules/schedule_walk.dart) | Dart | 48 | 0 | 9 | 57 |
| [lib/home/services/walker/agenda.dart](/lib/home/services/walker/agenda.dart) | Dart | 379 | 4 | 33 | 416 |
| [lib/home/services/walker/appointments_info/assign_salon.dart](/lib/home/services/walker/appointments_info/assign_salon.dart) | Dart | 488 | 0 | 25 | 513 |
| [lib/home/services/walker/appointments_info/assign_shopping.dart](/lib/home/services/walker/appointments_info/assign_shopping.dart) | Dart | 290 | 0 | 21 | 311 |
| [lib/home/services/walker/appointments_info/assign_sitting.dart](/lib/home/services/walker/appointments_info/assign_sitting.dart) | Dart | 431 | 0 | 23 | 454 |
| [lib/home/services/walker/appointments_info/assign_vet.dart](/lib/home/services/walker/appointments_info/assign_vet.dart) | Dart | 431 | 0 | 23 | 454 |
| [lib/home/services/walker/appointments_info/assign_walk.dart](/lib/home/services/walker/appointments_info/assign_walk.dart) | Dart | 383 | 0 | 22 | 405 |
| [lib/home/services/walker/available_appointments.dart](/lib/home/services/walker/available_appointments.dart) | Dart | 394 | 5 | 33 | 432 |
| [lib/home/services/walker/preferences_screen.dart](/lib/home/services/walker/preferences_screen.dart) | Dart | 310 | 0 | 37 | 347 |
| [lib/home/services/walker/search.dart](/lib/home/services/walker/search.dart) | Dart | 24 | 0 | 4 | 28 |

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details