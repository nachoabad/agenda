admin = User.create_with(password: "adminadmin", password_confirmation: "adminadmin", name: "Graciela Olmos", time_zone: "Madrid").find_or_create_by! email: "admin@mail.com"
service = admin.services.first_or_create! name: "Consultas", time_zone: "Madrid"

admin2 = User.create_with(password: "adminadmin", password_confirmation: "adminadmin", name: "Pedro Torrellas", time_zone: "Caracas").find_or_create_by! email: "admin2@mail.com"
service2 = admin2.services.first_or_create! name: "Consultas2", time_zone: "Caracas"

user = User.create_with(password: "useruser", password_confirmation: "useruser", name: "María Miami", time_zone: "Eastern Time (US & Canada)").find_or_create_by! email: "user@mail.com"

service.slot_rules.destroy_all
service.slot_rules.create! [
  {time: "10:00", wday: 1},
  {time: "11:30", wday: 1},
  {time: "13:00", wday: 1},
  {time: "14:30", wday: 1},
  {time: "16:00", wday: 1},
  {time: "17:30", wday: 1},
  {time: "19:00", wday: 1},
  {time: "20:30", wday: 1},
  {time: "10:00", wday: 2},
  {time: "11:30", wday: 2},
  {time: "13:00", wday: 2},
  {time: "14:30", wday: 2},
  {time: "16:00", wday: 2},
  {time: "17:30", wday: 2},
  {time: "19:00", wday: 2},
  {time: "20:30", wday: 2},
  {time: "10:00", wday: 3},
  {time: "11:30", wday: 3},
  {time: "13:00", wday: 3},
  {time: "14:30", wday: 3},
  {time: "16:00", wday: 3},
  {time: "17:30", wday: 3},
  {time: "19:00", wday: 3},
  {time: "20:30", wday: 3},
  {time: "10:00", wday: 4},
  {time: "11:30", wday: 4},
  {time: "13:00", wday: 4},
  {time: "14:30", wday: 4},
  {time: "16:00", wday: 4},
  {time: "17:30", wday: 4},
  {time: "19:00", wday: 4},
  {time: "20:30", wday: 4},
  {time: "10:00", wday: 5},
  {time: "11:30", wday: 5},
  {time: "13:00", wday: 5},
  {time: "14:30", wday: 5},
  {time: "16:00", wday: 5},
  {time: "17:30", wday: 5},
  {time: "19:00", wday: 5},
  {time: "20:30", wday: 5},
]