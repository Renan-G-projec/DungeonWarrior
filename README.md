# DungeonWarrior
A simple 8-bit dungeon game made in godot for hackclub thirdspace by 2 people

![Screenshot](.github/Slime.png)

## How to play
Access the live demo at https://renan-g.itch.io/dungeonwarrior :)

## Input
- WASD and arrow keys moves the player
- E interacts
- Clicking will trigger attack if you have a weapon

## About
The game is about a little warrior that needs to escape the dungeon where he is. To do that he needs to transit between rooms

## Mechanics
The game have a door system so it can reload the rooms quickly and grab context from where to go.
The game have different types of bullets, and weapons in general. There's a bow and a sword. More will be added.
We have inteligent enemies with raycasting and state machines! 
Theres slimes, chests, bats and shadow enemies to fight
There are a transition manager with a custom callback function

## Weapons
The game have the following weapons:
- Boomerang: Click and then it shoots
- Magic wand: Have 3 states (fire, which burns the enemies; psyquic, which is a little teleguiated; ice, which slows downs the enemies). You can switch by pressing e.
- Sword: The one which you spawn with, Has a little knockback
- Bow: Shoots by distance... causes some considerable damage

![Sword](.github/Sword.png)

## Enemies
There are these enemies:
- The boss with a pull attack
- The Slime which causes a little explosion
- The bat which rushes on the player
- The Ghost which uses a laser attack

![Boss](.github/Boss.png)
![Bat](.github/Bat.png)

## How to build
Clone the repo with `git clone https://github.com/Renan-G-projec.git`
Open the folder with godot and click the big run button :p

## AI Disclosure:
NONE AI was used for making the assets. A small amount of AI was used while debugging the game. The drawing time can be seen in https://lapse.hackclub.com/user/@renan