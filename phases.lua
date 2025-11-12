local Phases = {}

Phases.data = {
    [1] = {
        name = "Fase 1",
        coins = {
            { x = 300, y = 200 },
            { x = 400, y = 200 },
            { x = 500, y = 100 }
        },
        spikes = {
            { x = 220, y = 327 },
            { x = 195, y = 327 },
            { x = 170, y = 327 }
        },
        boxes = {
            { x = 510, y = 35 },
            { x = 600, y = 35 }
        },
        platforms = {
            { x = 600, y = 200, width = 100, height = 16 }
        },
        buttons = {
            { x = 540, y = 328, width = 64, height = 16 }
        },
        flag = { x = 300, y = 100 }
    },
    [2] = {
        name = "Fase 2",
        coins = {
            { x = 200, y = 150 },
            { x = 350, y = 250 }
        },
        spikes = {
            { x = 100, y = 327 }
        },
        boxes = {},
        platforms = {
            { x = 300, y = 200, width = 150, height = 16 }
        },
        buttons = {},
        flag = { x = 600, y = 50 }
    }
}

return Phases