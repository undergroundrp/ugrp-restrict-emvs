-- Instantiate config
Config = {}

-- Language file
Config.Locale = 'en'

-- Restrict emergency vehicles
Config.restricted = true

-- Jobs permitted to use emergency vehicles
Config.allowed = {
    'ambulance', 'mechanic', 'police'
}
