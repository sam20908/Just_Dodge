extends Node

var score = 0

const DIFFICULTY_NAMES = {
    1: "Easy",
    2: "Medium",
    3: "Hard",
    4: "Insane",
    5: "Impossible"
}

const DIFFICULTY_COLORS = {
    1: Color(0.176471, 0.780392, 0.141176), # green
    2: Color(0.780392, 0.694118, 0.141176), # yellow
    3: Color(0.854902, 0.258824, 0.160784), # orange
    4: Color(0.556863, 0.160784, 0.854902), # purple
    5: Color(0.160784, 0.839216, 0.854902)  # cyan
}
