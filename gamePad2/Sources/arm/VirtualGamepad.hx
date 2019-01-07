package arm;


import iron.system.Time;
import iron.App;
import kha.graphics2.Graphics;
import kha.graphics2.GraphicsExtension;
import iron.Trait;
import iron.system.Input;
import iron.math.Vec2;
import armory.trait.physics.RigidBody;
import haxe.Timer;



class VirtualGamepad extends Trait {

	var gamepad:Gamepad;

	var leftPadX = 0;
	var leftPadY = 0;
	var rightPadX = 0;
	var rightPadY = 0;

	var leftStickX = 0;
	var leftStickXLast = 0;
	var leftStickY = 0;
	var leftStickYLast = 0;
	var rightStickX = 0;
	var rightStickXLast = 0;
	var rightStickY = 0;
	var rightStickYLast = 0;

	var leftLocked = false;
	var rightLocked = false;

	

	var r = 50; // Radius
	var o = 20; // Offset

	
	private var Up:Int;
	private var Down:Int;
	private var Left:Int;

	private var TempoMovimento:Timer;

	public function new() {
		super();

		notifyOnInit(function() {
			
		

			

			notifyOnUpdate(update);
			notifyOnRender2D(render2D);
			TempoMovimento= new Timer(100);
			 Movimento();
			
			
		});
	}

	

	function update() {
		 object.getTrait(RigidBody).syncTransform();
		leftPadX = r + o;
		rightPadX = iron.App.w() - r - o;
		leftPadY = rightPadY = iron.App.h() - r - o;
		var mouse = Input.getMouse();
		if (mouse.started() && Vec2.distancef(mouse.x, mouse.y, leftPadX, leftPadY) <= r) {
			trace(leftPadX);
			leftLocked = true;
			
			
		}

		else if (mouse.released()) {
			leftLocked = false;
		
		}

		if (mouse.started() && Vec2.distancef(mouse.x, mouse.y, rightPadX, rightPadY) <= r) {
			rightLocked = true;
		}
		else if (mouse.released()) {
			rightLocked = false;
		}

		if (leftLocked) {
			leftStickX = Std.int(mouse.x - leftPadX);
			leftStickY = Std.int(mouse.y - leftPadY);

			var l = Math.sqrt(leftStickX * leftStickX + leftStickY * leftStickY);
			if (l > r) {
				var x = r * (leftStickX / Math.sqrt(leftStickX * leftStickX + leftStickY * leftStickY));
				var y = r * (leftStickY / Math.sqrt(leftStickX * leftStickX + leftStickY * leftStickY));
				leftStickX = Std.int(x);
				leftStickY = Std.int(y);
			}
		}
		else {
			leftStickX = 0;
			leftStickY = 0;
		}

		if (rightLocked) {
			rightStickX = Std.int(mouse.x - rightPadX);
			rightStickY = Std.int(mouse.y - rightPadY);

			var l = Math.sqrt(rightStickX * rightStickX + rightStickY * rightStickY);
			if (l > r) {
				var x = r * (rightStickX / Math.sqrt(rightStickX * rightStickX + rightStickY * rightStickY));
				var y = r * (rightStickY / Math.sqrt(rightStickX * rightStickX + rightStickY * rightStickY));
				rightStickX = Std.int(x);
				rightStickY = Std.int(y);
			}
		}
		else {
			rightStickX = 0;
			rightStickY = 0;
		}

		
		leftStickXLast = leftStickX;
		leftStickYLast = leftStickY;
		rightStickXLast = rightStickX;
		rightStickYLast = rightStickY;

		
		
		
		

		


	}

	function Movimento(){

		TempoMovimento.run=function (){
		Up=Std.int(App.h()/11);
		Down=Std.int(App.h()/4.5);
		Left=Std.int(App.h()/1.2);
		
		
		if(leftStickY>-49 && leftStickY<-25){
			trace("Up");
			object.transform.loc.x-=1;
			object.transform.buildMatrix();
		}

		if(49>leftStickY && leftStickY>25){
			trace("Down");
			object.transform.loc.x+=1;
			object.transform.buildMatrix();
		}

		
		if(leftStickX>-49 && leftStickX<-25){
			trace("Left");
			object.transform.loc.y-=1;
			object.transform.buildMatrix();

		}
		if(49>leftStickX && leftStickX>25){
			trace("Right");
			object.transform.loc.y+=1;
			object.transform.buildMatrix();

		}
	


		}
	}

	function render2D(g:kha.graphics2.Graphics) {
		g.color = 0xffaaaaaa;


		kha.graphics2.GraphicsExtension.fillCircle(g, leftPadX, leftPadY, r);
	//	kha.graphics2.GraphicsExtension.fillCircle(g, rightPadX, rightPadY, r);

		var r2 = Std.int(r / 2.2);
		g.color = 0xffffff44;
		kha.graphics2.GraphicsExtension.fillCircle(g, leftPadX + leftStickX, leftPadY + leftStickY, r2);
		//kha.graphics2.GraphicsExtension.fillCircle(g, rightPadX + rightStickX, rightPadY + rightStickY, r2);
		
		
	
		g.color = 0xffffffff;
	}
}
