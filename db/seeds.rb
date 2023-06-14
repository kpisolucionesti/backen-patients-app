# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Room.destroy_all
adulto_rooms=[
    'Cubiculo 1',
    'Cubiculo 2',
    'Cubiculo 3',
    'Cubiculo 4',
    'Cubiculo 5',
    'Cubiculo 6',
    'Aislamiento 1',
    'Aislamiento 2',
    'Traumashock',
]

kids_rooms=[
    'Cubiculo 1',
    'Cubiculo 2',
    'Aislamiento',
    'Traumashock',
]

adulto_rooms.each do |i|
    Room.create(name: i, room_type: 'adulto')
end

kids_rooms.each do |i|
    Room.create(name: i, room_type: 'pediatria')
end