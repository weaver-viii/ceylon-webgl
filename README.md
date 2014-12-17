Ceylon three.js example  
==========
This is a [Ceylon](http://ceylon-lang.org/) port of the [three.js](http://threejs.org) custom attributes [example](http://threejs.org/examples/webgl_custom_attributes.html).

The main code of the example was ported in Ceylon, but of course, the Ceylon example still depends on the original [three.js](https://github.com/mrdoob/three.js) library for the 3D, and the [stats.js](https://github.com/mrdoob/stats.js) library to display the FPS.

Why ?
-----
I'm in interested in Ceylon, I was experimenting with its JS interop features, and I was looking for an interesting small project to learn more.

I heard about the three.js libs and was amazed by the online examples. And given that I'm an absolute beginner in 3D, it was also an oportunity to learn even more.

Why this example ?
---------------------

Because I found the graphics beautifull, the code is rather small, and there are Vertex and Pixel shaders used in the code, and I irrationally wanted to program the GPU of my graphic cards in Ceylon (uhm... ok... not really in Ceylon, of course the code is still GLSL).

Is this really a valid use case for Ceylon ?
---------------------

Frankly ? I don't know. I mean, this use case is a micro benchmark as sush, and probably not the main target for Ceylon.

And I happily admit that the Ceylon port is not on a par with the original JS example FPS-wise. I suspect it has something to do with the GC of the browser when to much Ceylon code is involved in the main render loop (hey, this thing is a micro benchmark as sush ! )

That's why I decided to keep a bit of native JS for the core render loop that must update a large array of floats (8000 elements at each frame).

That being said

* My Ceylon code itself is not optimal and can surely be optimized
* The raw performance of Ceylon itself is improving everyday


Was it worthwile ?
---------------------

For me, Yes. 

The three.js API is beautiful, and it was a rewarding experience to combine it with the [dynamic interfaces of Ceylon](http://ceylon-lang.org/documentation/1.1/tour/dynamic/).

Also, it demonstrates that the interop capabilties of Ceylon with JS even for this rather extreme use case.

 