from random import Random, randint
import turtle
from unittest import result

class GraphNode:
    def __init__(self, i, j):
        self.i = i
        self.j = j
    def __str__(self) -> str:
        return f"({self.i}, {self.j})"
    def toTuple(self) -> tuple:
        return (self.i, self.j)

# https://www.pythonpool.com/kruskals-algorithm-python/
class Graph:
    def __init__(self, nodes: "list[GraphNode]"):
        self.nodes : list[GraphNode] = nodes
        self.edges : list[tuple] = []
    def add_edge(self, u, v, w):
        self.edges.append((u, v, w))
    def search(self, parent, i):
        if(parent[i] == i): return i
        return self.search(parent, parent[i])
    def apply_union(self, parent, rank, x, y):
        x_root = self.search(parent, x)
        y_root = self.search(parent, y)
        if rank[x_root] < rank[y_root]:
            parent[x_root] = y_root
        elif rank[x_root] > rank[y_root]:
            parent[y_root] = x_root
        else:
            parent[y_root] = x_root
            rank[x_root] += 1 

    def kruskal(self):
        result = []
        i, e  = 0, 0
        # sort edges
        self.edges = sorted(self.edges, key=lambda x: x[2])
        # Init empty parent and rank
        parent, rank = [], []
        for i, node in enumerate(self.nodes):
            parent.append(i)
            rank.append(0)
        while e < len(self.nodes) - 1:
            u, v, w = self.edges[i]
            i += 1
            x = self.search(parent, u)
            y = self.search(parent, v)
            if x != y:
                e += 1
                result.append((u, v, w))
                self.apply_union(parent, rank, x, y)
        return result

def generateGraph(n) -> Graph:
    nodes : list[GraphNode] = []
    for i in range(n):
        for j in range(n):
            nodes.append(
                GraphNode(i, j)
            )
    return Graph(nodes)

def generateEdges(graph: Graph, n):
    # Iterate over each node
    for i, node in enumerate(graph.nodes):
        # top (-n)
        top_index = i - n
        if(top_index >= 0 and graph.nodes[top_index].i < node.i):   graph.add_edge(i, top_index, randint(a=1, b=10))
        # right (+1)
        right_index = i + 1
        if(right_index < len(graph.nodes)-1 and graph.nodes[right_index].j > node.j):   graph.add_edge(i, right_index, randint(a=1, b=10))
        # bottom (+n)
        bottom_index = i + n
        if(bottom_index < len(graph.nodes)-1 and graph.nodes[bottom_index].i > node.i):   graph.add_edge(i, bottom_index, randint(a=1, b=10))
        # left (-1)
        left_index = i - 1
        if(left_index >= 0 and graph.nodes[left_index].j < node.j):   graph.add_edge(i, left_index, randint(a=1, b=10))
    return graph.edges


if __name__ == "__main__":
    n = 11
    graph = generateGraph(n)
    edges = generateEdges(graph, n)

    screen = turtle.Screen()
    screen.xscale = 20
    screen.yscale = 20
    screen.bgcolor("black")
    for item in graph.kruskal():
        print(item)
        turtle.color('white')
        turtle.hideturtle()
        turtle.width(10)
        turtle.penup()
        turtle.goto(graph.nodes[item[0]].toTuple())
        turtle.pendown()
        turtle.goto(graph.nodes[item[1]].toTuple())
        turtle.penup()


    turtle.exitonclick() 