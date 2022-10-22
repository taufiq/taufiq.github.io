---
layout: post
title:  "TIL Flood Fill"
date:   2022-10-23 00:08:29 +0800
categories: jekyll update
---
*Well it's more of just a single flood fill question on leetcode...*

Anyways, behold! An "*easy*" question from LeetCode: [Flood Fill][floodfill-link].

![Diagram of the problem](/images/floodfill.jpeg)

Basically, you choose a starting square and a colour (let's call it C) you want to flood fill with. From the starting square you need to find adjacent (horizontally and vertically) squares with the same colour as the starting square, and then find adjacted squares with the same colour of those adjacent square, so on and so forth. Once you've found a network of these connected squares, you can then set them to colour C.

So in the diagram above, the starting square (in red) has a colour 1, intended colour (C) to flood fill with is 2, and the blue squares shows the network of squares that are adjacently connected and to have their colours changed from 1 to 2.


Now, I've never done graph-related questions before and this was abit of a struggle to figure out. After some googling, I discovered this search called Depth-First Search (DFS), which seemed to align with a possible solution for this problem.

From a starting node, we explore one chain of nodes all the way first before backtracking to explore another chain of nodes. So it'd look something like this:
```
       -> C -> D
A -> B      
       -> E -> F -> G 
```
So the exploration would look something like this:

```
A -> B -> C -> D -> E -> F -> G
```

Since this challenge looked exactly like a graph, it seemed reasonable to attempt DFS on this problem as we need to find recursively find all adjacent similar colored squares first before changing the colour.

{% highlight java %}
public void dfs(int[][] map, int row, int col, int color) {
    if (row < 0 || col >= map.length) {
        return;
    }
    if (row < 0 || col >= map[0].length) {
        return;
    }
    if (map[row][col] != color) {
        return;
    }
    if (visited.contains(new ArrayList<>(List.of(row, col)))) {
        return;
    }
    
    visited.add(new ArrayList<>(List.of(row, sc)));
    dfs(map, row - 1, col, color);
    dfs(map, row, col - 1, color);
    dfs(map, row + 1, col, color);
    dfs(map, row, col + 1, color);
}
{% endhighlight %}

How I understood it was that, the DFS here works by exploring the left most nodes possible, adding it to a list of visited nodes if the colour matches with the starting square. Once it can't go any further, the top nodes are then explored, and then the right, and then the bottom nodes. We store a list of visited nodes so that if we travel back to a already visited node, we can know through the list and don't have to attempt DFS again on that node.

Now we have the network of squares stored in the visited nodes, we can then iterate through the list and set the colours of it.

Here was the full code I wrote for it, probably not optimal as this was my first time implementing DFS blindly. I'm pretty happy as I've never done graph questions like this before and it was fun solving it!

{% highlight java %}
import java.util.*;

class Solution {
    Set<ArrayList<Integer>> visited = new HashSet<>();
        
    public void dfs(int[][] map, int sr, int sc, int color) {
        if (sr < 0 || sr >= map.length) {
            return;
        }
        if (sc < 0 || sc >= map[0].length) {
            return;
        }
        if (map[sr][sc] != color) {
            return;
        }
        if (visited.contains(new ArrayList<>(List.of(sr, sc)))) {
            return;
        }
        
        visited.add(new ArrayList<>(List.of(sr, sc)));
        dfs(map, sr - 1, sc, color);
        dfs(map, sr, sc - 1, color);
        dfs(map, sr + 1, sc, color);
        dfs(map, sr, sc + 1, color);
    }

    public int[][] floodFill(int[][] image, int sr, int sc, int color) {
        dfs(image, sr, sc, image[sr][sc]);
        Iterator<ArrayList<Integer>> i = visited.iterator();
        while(i.hasNext()) {
            ArrayList<Integer> coord = i.next();
            image[coord.get(0)][coord.get(1)] = color;
        }
    
        return image;
    }
}
{% endhighlight %}

[floodfill-link]: https://leetcode.com/problems/flood-fill/description/
