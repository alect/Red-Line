package Utilities
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxPoint;
	
	/**
	 * Here's where our A* function for all the pathfinding is located
	 */
	public class AStar
	{
		
		
		public static function A_Star(start:FlxPoint, destination:FlxPoint, board:Array, columns:int, rows:int):Array
		{
			//Alright, start off by making start and destination be real nodes
			var startNode:Node = new Node(int(start.x), int(start.y), -1, -1, -1, -1);
			var destinationNode:Node = new Node(int(destination.x), int(destination.y), -1, -1, -1, -1);
			
			var open:Array = []; //List of open nodes (nodes to be inspected)
			var closed:Array = []; //List of closed nodes (nodes we've already inspected)
			
			var g:Number = 0; //Cost from start to current node
			var h:Number = heuristic(startNode, destinationNode); //Cost from current node to destination
			var f:Number = g+h; //Cost from start to destination going through the current node
			
			//Push the start node onto the list of open nodes
			open.push(startNode);
			
			//Keep going while there's nodes in our open list
			while(open.length > 0)
			{
				//Need to find the best open node (lowest f value)
				
				//Normally I would do this with a priority queue
				//but Actionscript doesn't have one and I'm too lazy to make my own right now
				var best_cost:Number =  (open[0] as Node).f;
				var best_node:int = 0;
				
				for (var i:int = 0; i < open.length; i ++)
				{
					if ((open[i] as Node).f < best_cost)
					{
						best_cost = (open[i] as Node).f;
						best_node = i;
					}
				}
				
				var current_node:Node = (open[best_node] as Node);
				
				//Check if we've reached our destination
				if(current_node.x == destinationNode.x && current_node.y == destinationNode.y)
				{
					var path:Array = [destinationNode.toFlxPoint()]; //Initialize the path with the destination node
					
					//Go up the chain to recreate the path
					while(current_node.parent_index != -1)
					{
						current_node = closed[current_node.parent_index];
						path.push(current_node.toFlxPoint());
					}
					
					//Since we built the path backwards, need to reverse it before returning it
					return path.reverse();
				}
				
				
				//Remove the current node from our open list
				open.splice(best_node, 1);
				
				//Push it onto the closed list
				closed.push(current_node);
				
				//Expand our current node (look in all 8 directions)
				for(var new_node_x:int = Math.max(0, current_node.x-1); new_node_x <= Math.min(columns-1, current_node.x+1); new_node_x++)
				{
					for(var new_node_y:int = Math.max(0, current_node.y-1); new_node_y <= Math.min(rows-1, current_node.y+1); new_node_y++)
					{
						if ((board[new_node_x][new_node_y] == 0 //If the new Node is open
							|| (destinationNode.x == new_node_x && destinationNode.y == new_node_y)) // or the new node is our destination
							&& (new_node_x == current_node.x || new_node_y == current_node.y)) // ignoring diagonals
						{
							//First, see if the new node is already in our closed list. If so, skip it
							var found_in_closed:Boolean = false;
							for each(var node_i:Node in closed)
							{
								if(node_i.x == new_node_x && node_i.y == new_node_y)
								{
									found_in_closed = true;
									break;
								}
							}
							if(found_in_closed)
								continue;
							
							
							//See if the node is in our open list. If not, use it. 
							var found_in_open:Boolean = false;
							for each(var node_j:Node in open)
							{
								if(node_j.x == new_node_x && node_j.y == new_node_y)
								{
									found_in_open = true;
									break;
								}
							}
							if (!found_in_open)
							{
								var new_node:Node = new Node(new_node_x, new_node_y, closed.length-1, -1, -1, -1);
								new_node.g = current_node.g + Math.floor(Math.sqrt(Math.pow(new_node.x-current_node.x, 2)+Math.pow(new_node.y-current_node.y, 2)));
								new_node.h = heuristic(new_node, destinationNode);
								new_node.f = new_node.g+new_node.h;
								
								open.push(new_node);
							}
							
							
						}
					}
				}
				
			}
			
			//And if we really weren't able to find a path, go ahead and return an empty array. 
			return [];
			
			
		}
		
		
		private static function heuristic(current_node:Node, destination:Node):Number
		{
			return Math.floor(Math.sqrt(Math.pow(current_node.x-destination.x, 2)+Math.pow(current_node.y-destination.y, 2)));
		}
	}
}

import org.flixel.FlxPoint;
import Utilities.Globals;
/**
 * A special class only accessible to our a* function. Kind of like a struct
 *
 */
class Node
{
	public var x:int, y:int, parent_index:int;
	public var g:Number, h:Number, f:Number;
	
	public function Node(x:int, y:int, parent_index:int, g:Number, h:Number, f:Number)
	{
		this.x = x;
		this.y = y;
		this.parent_index = parent_index;
		this.g = g;
		this.h = h;
		this.f = f;
	}
	
	public function toFlxPoint():FlxPoint
	{
		return new FlxPoint(this.x*Globals.GRID_CELL_SIZE, this.y*Globals.GRID_CELL_SIZE);
	}
}
