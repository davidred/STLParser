##STL Parser

The STL file format is widely used across different 3D printing and modeling interfaces. It describes a surface composed of a number of triangles. The triangles are represented by a unit normal and list of 3 cartesian coordinates that make up each triangle.

This Ruby program parses an STL file and returns the number of faces, corners, and vertices that are in the file.

##Install Instructions

- Clone the repository and run bundle install
- Type rspec to run tests
- Type bin/STLParser to run program
- To parse another STL file, copy it into the data folder and name it 'cube.stl'

##How it works

An STL File is made up of a lot of these triangles:

```
facet normal ni nj nk
  outer loop
    vertex v1x v1y v1z
    vertex v2x v2y v2z
    vertex v3x v3y v3z
  endloop
endfacet
```

The STL file was parsed and each distinct normal was represented in a separate graph data structure (stl_graph.rb). A face in this normal graph is made up of vertices on the same plane. If the vertices are on a different plane, this represents a different face.

If a path could not be found between two vertices, they must be on separate planes, indicating this is a separate face. Finding this was accomplished by a depth first search to determine the number of connected components in the file (stl_cc.rb)

A vertex is a corner if it connects at least three faces. Corners were found using a hashmap where each vertex is a key and its value is an array of normal vectors this vertex is related to.
