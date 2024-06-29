# A Foray into the Virtual World

Like many people, I personally enjoy gaming from time to time, and have often wondered at the intricacies of 3D modelling into a 2D world, (I.E., our computer screens!). This project arose from a desire to gain a better understanding of this concepts. To effectively transition a model created by an artist into a video game, and more specifically, a virtual, environment, a series of view transformations need to be performed. This allows us to take a 3D model and map its appearance onto a 2D screen. This is essentially what a CAD system does when it shows a 3D object that can be manipulated by a mouse, but in this project, I've coded that process myself as an exercise!

## Pre-coding considerations

While I considered coding this in Python, the allure of using matlab was too overwhelming to pass up. This project is driven almost entirely by matrix manipulation via different "transforms", allowing us to map a .raw file consisiting of an image composed of "raw triangles". Triangles are choosen because they are the simplest polygon, allowing for faster rendering times in an industry that lives and dies by the amount of frames pumped out per second. I've included the raw mesh image I used for the project below for refrence:

<div>
	<img src="/images/shark_triangle.png" width="700" >
</div>
(Technically this image was created after the object was oriented for the viewer in a later projection, but this makes it easier to visualize and really only changes the orientation from a purely visual perspective)

Because of these considerations, matlab became the natural first choice despite its lower use cases as compared to python or C# in the video game industry. Matlab is great at matrix manipulation, and it's guranteed that will be needed for this project.

## Mathemtical Background
Like I said above, the crux of this project is performing a series of transformations on the base .raw file for our image of choice. When read into an ide, the .raw file for an image properly formatted into triangular vertex format will display a nine column by x row matrix. The rows are dependent on the surface area of the object. These nine rows denote the X, Y, and Z coordinates of each triangle's vertices:

<div>
	<img src="/images/raw_read_output.png" width="700" >
</div>

Depending on what video game developer base you're working with, there are different conventions for whether to rearrange this data for ease of processing into a layout where the X, Y, and Z coordiantes are the columns, with rows representing a point, or where the X, Y, and Z coordinates are the rows, with the columns representing a point. Since I prefer Unity due to its relatively creator friendly conditions for use, I'll be using the former. 

From here, we can begin with the bulk of the mathematics. Currently, our model is floating in space in reference to its own position, but this serves us no good if we want to put it in a specific world coordinate for the viewer to see. So we will apply a "world transform" to get the model in the correct position and orientation in relation to the world coordinates set at the beginning of the program. This transform consists of multiplying our model matrix by a transform matrix and three rotation matrices, for the X, Y, and Z axis. Keep in mind that the order of rotation does matter! So make sure you're consistent.

### Transform matrix
<table>
  <tr>
    <td>1</td>
    <td>0</td>
    <td>0</td>
	  <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>0</td>
	  <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>1</td>
	  <td>0</td>
  </tr>
	<tr>
    <td>Tx</td>
    <td>Ty</td>
    <td>Tz</td>
		<td>1</td>
  </tr>
</table>

### X Rotation matrix
<table>
  <tr>
    <td>1</td>
    <td>0</td>
    <td>0</td>
	  <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>cos(&theta)</td>
    <td>sin(&theta)</td>
	  <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>-sin(&theta)</td>
    <td>cos(&theta)</td>
	  <td>0</td>
  </tr>
	<tr>
    <td>0</td>
    <td>0</td>
    <td>0</td>
		<td>1</td>
  </tr>
</table>

### Y Transform matrix
<table>
  <tr>
    <td>cos(&theta)</td>
    <td>0</td>
    <td>-sin(&theta)</td>
	  <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>0</td>
	  <td>0</td>
  </tr>
  <tr>
    <td>sin(&theta)</td>
    <td>0</td>
    <td>cos(&theta)</td>
	  <td>0</td>
  </tr>
	<tr>
    <td>0</td>
    <td>0</td>
    <td>0</td>
		<td>1</td>
  </tr>
</table>
### Z Rotation matrix
<table>
  <tr>
    <td>cos(&theta)</td>
    <td>sin(&theta)</td>
    <td>0</td>
	  <td>0</td>
  </tr>
  <tr>
    <td>-sin(&theta)</td>
    <td>cos(&theta)</td>
    <td>0</td>
	  <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>1</td>
	  <td>0</td>
  </tr>
	<tr>
    <td>0</td>
    <td>0</td>
    <td>0</td>
		<td>1</td>
  </tr>
</table>

From there, we will need to do two more transforms, one to apply a view transformation to move the model into the "eyespace coordinates" of the viewer, and one to apply a projection transformation to move te model into normalized coordinates on the screen. From there, the object has been moved into position, and we can begin adding lighting to create shading, as well as implement a form of Z-culling to remove the plotting of any coordinates behind another. This will eliminate the overshadow effect going on in the above picture! 

## Final results
With all of this done, we now have a finished image! 

<div>
	<img src="/images/shark_final.png" width="700" >
</div>

I added some color as well that can be adjusted in the rawReads function of the program. While I used a shark for this project, the program will run on any image that is successfully converted into the .raw triangular vertice format used in this project. Depending on how you create the file, your read conditions may change slightly, which can be adjusted in the worldM function, but for the most part this is a seamless integration for anyone interested!
