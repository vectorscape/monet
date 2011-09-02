package com.velti.monet.utils {
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * Class that assists with drawing on the screen,
	 * typically by manipulating a <code>flash.display.Graphics</code>
	 * object.
	 * 
	 * @author Ian Serlin
	 */	
	public class DrawingUtil {
		
		/**
		 * Draws a line directly from the start point to the end point using the given graphics object.
		 *  
		 * @param startPoint
		 * @param endPoint
		 * @param g
		 */		
		public static function drawStraightLine( startPoint:Point, endPoint:Point, g:Graphics ):void {
			g.moveTo( startPoint.x, startPoint.y );
			g.lineTo( endPoint.x, endPoint.y );
		}
		
		/**
		 * Draws a line using right angles from the start point to the end point 
		 * using the given graphics object.
		 *  
		 * @param startPoint
		 * @param endPoint
		 * @param angleAfter a value between 0.0-1.0 that determines where the angle in the line will be drawn
		 * @param g
		 */		
		public static function drawRightAngleLine( startPoint:Point, endPoint:Point, g:Graphics, angleAfter:Number ):void {
			var horizontalDistance:Number = endPoint.x - startPoint.x;
			var angleAt:Number = horizontalDistance * angleAfter;
			
			g.moveTo( startPoint.x, startPoint.y );
			g.lineTo( startPoint.x + angleAt, startPoint.y );
			g.lineTo( startPoint.x + angleAt, endPoint.y ); 
			g.lineTo( endPoint.x, endPoint.y );
		}
		
	}
}