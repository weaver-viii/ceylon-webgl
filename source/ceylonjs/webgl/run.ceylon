import ceylonjs.webgl.three {
    three,
    PerspectiveCamera,
    Scene,
    Geometry,
    Color,
    Mesh,
    ShaderMaterialParam,
    ShaderMaterial,
    Texture,
    ShaderValueBundle,
    ShaderValue
}

String vertexshader = 
        """
           
           uniform float amplitude;
           
           attribute float displacement;
           
           varying vec3 vNormal;
           varying vec2 vUv;
           
           void main() {
           
                vNormal = normal;
                vUv = ( 0.5 + amplitude ) * uv + vec2( amplitude );
           
                vec3 newPosition = position + amplitude * normal * vec3( displacement );
                gl_Position = projectionMatrix * modelViewMatrix * vec4( newPosition, 1.0 );
           
           }                        
           
                                            
           """;

String fragmentshader = 
        """
                           
           varying vec3 vNormal;
           varying vec2 vUv;
           
           uniform vec3 color;
           uniform sampler2D texture;
           
           void main() {
           
                vec3 light = vec3( 0.5, 0.2, 1.0 );
                light = normalize( light );
           
                float dProd = dot( vNormal, light ) * 0.5 + 0.5;
           
                vec4 tcolor = texture2D( texture, vUv );
                vec4 gray = vec4( vec3( tcolor.r * 0.3 + tcolor.g * 0.59 + tcolor.b * 0.11 ), 1.0 );
           
                gl_FragColor = gray * vec4( vec3( dProd ) * vec3( color ), 1.0 );
           
           }
           
                           
           """;


shared void run() {
   
    NativeFuncs nativeFuncs = ((){ dynamic{ return jsNativeFuncs; } })();
   
    Integer screenWidth = win.innerWidth;
    Integer screenHeight = win.innerHeight;
    PerspectiveCamera camera =  three.perspectiveCamera( 30, screenWidth / screenHeight, 1, 10000 );
    camera.position.z = 300;
    
    Scene scene = three.scene();
    
    Geometry sphereGeometry = three.sphereGeometry{ 
        radius = 50;
        widthSegments = 128;
        heightSegments = 64;
    };
    sphereGeometry.\idynamic = true;
  
    value verticesIdx = 0:sphereGeometry.vertices.size;
    Array<Float> noise = Array { for (i in verticesIdx) random() * 5 };
    Array<Float> displacementValues = Array { for (i in verticesIdx) 0.0 };
    object attributes extends ShaderValueBundle(){
        shared ShaderValue<Array<Float>> displacement = ShaderValue("f",displacementValues);
    }
    object uniforms extends ShaderValueBundle(){
        shared ShaderValue<Float> amplitude = ShaderValue("f",1.0);
        shared ShaderValue<Color> color = ShaderValue("c", three.color(#ff2200) );
        shared ShaderValue<Texture> texture = ShaderValue("t", three.imageUtils.loadTexture( "textures/water.jpg" ) );
        
    }
    
    
    ShaderMaterialParam sharedMaterialParam;
    dynamic{

        dynamic dynUniforms = uniforms.createDyn();
        dynamic dynAttributes = attributes.createDyn();
        dynUniforms.texture.\ivalue.wrapS = dynUniforms.texture.\ivalue.wrapT = THREE.\iRepeatWrapping;
        
        sharedMaterialParam = ShaderMaterialParam{
            attributes = dynAttributes;
            uniforms = dynUniforms;
            vertexShader = vertexshader;
            fragmentShader = fragmentshader;
        };
        
    }
    ShaderMaterial shaderMaterial = three.shaderMaterial(sharedMaterialParam);
    
    Mesh sphere = three.mesh( sphereGeometry, shaderMaterial );
    
    scene.add( sphere );
    value renderer = three.webGLRenderer();
    renderer.setClearColor( #050505, 1 );
    renderer.setSize( screenWidth, screenHeight );
    
    void onWindowResize() {
        value w = win.innerWidth;
        value h = win.innerHeight;
        camera.aspect = w.float / h.float;
        camera.updateProjectionMatrix();
        renderer.setSize( w, h );
    }
    
    win.addEventListener( "resize", onWindowResize);
    
    
    dynamic stats;
    dynamic{
        dynamic container = document.body;
        container.appendChild( renderer.domElement );
        
        stats = Stats();
        stats.domElement.style.position = "absolute";
        stats.domElement.style.top = "0px";
        container.appendChild( stats.domElement );
    }
     
   
    
    void render(){
        value time = now() * 0.01;
        sphere.rotation.y = sphere.rotation.z = 0.01 * time;
        
        uniforms.amplitude.val = 2.5 * sin( sphere.rotation.y * 0.125 );
        uniforms.color.val.offsetHSL( 0.0005, 0, 0 );
      
        nativeFuncs.updateDisplacement(time, displacementValues, noise);
        attributes.displacement.needsUpdate = true;
   
        renderer.render( scene, camera );
        
    }
    
    void animate() {
        
        three.requestAnimationFrame( animate );
        render();
        dynamic{
            stats.update();
        }
        
    }
    
    animate();
    
    
}


Float random(){
    dynamic{
        return Math.random();
    }
}

Integer now(){
    dynamic{
        return Date.now();
    }
}

Float sin(Float a){
    dynamic{
        return Math.sin(a);
    }
}

object win{
    
    shared Integer innerWidth{
        dynamic {
            return window.innerWidth;
        }
    }
    shared Integer innerHeight{
        dynamic {
            return window.innerHeight;
        }
    }
  
   shared void addEventListener( String type, void listener(), Boolean useCapture = false){
      dynamic{
          window.addEventListener(type, listener, useCapture);
      } 
  }
   
}

dynamic NativeFuncs{
    shared formal void updateDisplacement(Float time, Array<Float> displacementValues, Array<Float> noise);
}



