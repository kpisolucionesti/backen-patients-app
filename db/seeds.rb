User.destroy_all
User.create!(
  email: "admin@emerboard.com",
  password: "123456",
  password_confirmation: "123456",
  name: "Admin",
  confirmed_at: Time.current
)

Room.destroy_all
adulto_rooms=[
    'Cubiculo 1',
    'Cubiculo 2',
    'Cubiculo 3',
    'Cubiculo 4',
    'Cubiculo 5',
    'Cubiculo 6',
    'Cirugia Menor',
    'Consultorio',
    'Traumashock',
    'Sillon 1',
    'Sillon 2',
    'Sillon 3',
    'Sillon 4',
]

kids_rooms=[
    'Cubiculo 1',
    'Cubiculo 2',
    'Consultorio',
    'Traumashock',
]

Doctor.destroy_all
medicos=[
    {
        name: "ALBA AMUNDARAY",
        speciality: "CIRUGIA PLASTICA"
    },
    {
        name: "ALEXANDER MORALES",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "ANIBAL ROJAS",
        speciality: "ODONTOLOGIA"
    },
    {
        name: "AURA CONTRERAS",
        speciality: "NEUROCIRUGIA"
    },
    {
        name: "CARLA GONZALEZ",
        speciality: "ORL"
    },
    {
        name: "CRUZ GARBAN",
        speciality: "GINECOLOGIA"
    },
    {
        name: "DAVID MAGO",
        speciality: "GASTROENTEROLOGIA"
    },
    {
        name: "EDGAR VALOA",
        speciality: "NEUMONOLOGIA"
    },
    {
        name: "EDUARDO BILBAO",
        speciality: "TRAUMATOLOGIA"
    },
    {
        name: "FRANKY TORRES",
        speciality: "INTENSIVISTA"
    },
    {
        name: "GERSON ZAMBRANO",
        speciality: "INTENSIVISTA"
    },
    {
        name: "GIANCARLO ROTUNNO",
        speciality: "UROLOGIA"
    },
    {
        name: "GLADYS MOTA",
        speciality: "MEDICINA INTERNA"
    },
    {
        name: "IGOR MARQUEZ",
        speciality: "NEUROCIRUGIA"
    },
    {
        name: "JENNY MARTINEZ",
        speciality: "MEDICINA INTERNA"
    },
    {
        name: "JHOSBELIS GARCIA",
        speciality: "MEDICINA INTERNA"
    },
    {
        name: "JOSE MEDINA",
        speciality: "UROLOGIA"
    },
    {
        name: "JOSE NEGRIN",
        speciality: "TRAUMATOLOGIA"
    },
    {
        name: "JOSE RAMON NOYA",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "JOSE SANGUINO",
        speciality: "NEUROCIRUGIA"
    },
    {
        name: "LETTY CHAVEZ",
        speciality: "TRAUMATOLOGIA"
    },
    {
        name: "LILIANA DE LA FUENTE",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "MARIANA LOSSADA",
        speciality: "ORL"
    },
    {
        name: "MARISELA MENDEZ",
        speciality: "OFTALMOLOGIA"
    },
    {
        name: "MAYDA MARTINEZ",
        speciality: "GINECOLOGIA"
    },
    {
        name: "MERFRA PINERO",
        speciality: "GINECOLOGIA"
    },
    {
        name: "NACCY MORALES",
        speciality: "ODONTOLOGIA"
    },
    {
        name: "NATALIA MOTA",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "NORIS MARTINEZ",
        speciality: "GINECOLOGIA"
    },
    {
        name: "PETER KNAPP",
        speciality: "CIRUGIA GENERAL"
    },
    {
        name: "RAFAEL CHAVERO",
        speciality: "CARDIOLOGIA"
    },
    {
        name: "RICCIARDELLI GAETANO",
        speciality: "GINECOLOGIA"
    },
    {
        name: "RUBEN SIFONTES",
        speciality: "OFTALMOLOGIA"
    },
    {
        name: "SANDRA PEREZ",
        speciality: "CARDIOLOGIA"
    },
    {
        name: "SUSANA SALAZAR",
        speciality: "MEDICINA INTERNA"
    },
    {
        name: "YASMIN ALFONZO",
        speciality: "GASTROENTEROLOGIA"
    },
    {
        name: "ZAIDA GARRIDO",
        speciality: "CIRUGIA PLASTICA"
    }
]

adulto_rooms.each do |i|
    Room.create(name: i, room_type: 'adulto')
end

kids_rooms.each do |i|
    Room.create(name: i, room_type: 'pediatria')
end

medicos.each do |i|
    Doctor.create(i)
end