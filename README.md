# Just Dodge!

![New Version Intro Screen](/doc/Intro_New.png)

### :scroll: Purpose

This is the game I took from Godot's first game tutorial and turned it into something bigger. This was my introduction to game development as well as thinking like a game developer. This was something new and fresh from the other projects I have been working on because it feels like starting from the ground up again.

### :notebook: Development Timeline (To Present)

I knew that I wanted to start with something simple. With this in mind, I also knew I wanted a game engine that has the features I need (2D development, 3D development, and scripting capabilities) without nothing else, and that is when I found **Godot Engine**. Godot has the features I wanted as well as a very easy scripting language to do scripting with, and it was a breeze to learn because their tutorals are very easy to follow and the UI of the engine looked very clean and organized.

##### :crown: After completing Godot's first game tutorial, I have already gained sufficient amount of knowledge to expand the game I wanted to. These are what I learned:

* There are nodes that does exactly what you want and have the appropriate signals to make your life easier
* Setting up the in-game UI isn't really that hard, especially if you want to create flexible UIs for different displays, because Godot offers super basic yet useful containers to put elements in
* How to modularize the game in a way that it's easier to maintain and expand the game. For example, you can create "mob" scene (which can be seen as a mob *prefab* in Unity) with the logic only for the mob to function. You can then create instances of mob in your "game" scene without much fuss.
* Refreshed my memory on basic math and physics (radians, vectors, etc)

##### :white_check_mark: When I began expanding the game, I implemented these changes:

* Use a wider resolution (instead of the mobile resolution from the tutorial)
* Mobs "try" to go towards the player but there are random factors to make them "miss"
* Increase in difficulty as time went on. It does this by having a timer allowing a certain amount of time for a difficulty, and then it would do some logic to increase the difficulty:
    - Increased the minimum and maximum speed the mob can travel
    - Increased mob spawn rate
    - Reduce the randomness of the mob travelling location in a way that it has less chance to miss the player

![Impossible Mode](/doc/Impossible.png)
