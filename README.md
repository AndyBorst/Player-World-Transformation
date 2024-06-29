# A Foray into the Virtual World

Like many people, I personally enjoy gaming from time to time, and have often wondered at the intricacies of 3D modelling into a 2D world, (I.E., our computer screens!). This project arose from a desire to gain a better understanding of this concepts. To effectively transition a model created by an artist into a video game, and more specifically, a virtual, environment, a series of view transformations need to be performed. This allows us to take a 3D model and map its appearance onto a 2D screen. This is essentially what a CAD system does when it shows a 3D object that can be manipulated by a mouse, but in this project, I've coded that process myself as an exercise!

## Pre-coding considerations

While I considered coding this in Python, the allure of using matlab was too overwhelming to pass up. This project is driven almost entirely by matrix manipulation via different "transforms", allowing us to map a .raw file consisiting of an image composed of "raw triangles". Triangles are choosen because they are the simplest polygon, allowing for faster rendering times in an industry that lives and dies by the amount of frames pumped out per second.

<div>
	<img src="/images/shark_triangle.png" width="700" >
</div>

Because of this, matlab became the natural first choice despite its lower use as compared to python or C# in the video game industry. 
