//
//  Math3D.h
//  ice
//
//  Created by alxn1 on 26.09.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct
{
    float x;
    float y;
    float z;

    float u;
    float v;
} Vertex;

typedef struct
{
    float a11, a21, a31, a41;
    float a12, a22, a32, a42;
    float a13, a23, a33, a43;
    float a14, a24, a34, a44;
} Matrix;

Matrix IdentityMatrix(void);

Matrix RotateXMatrix(float angle);
Matrix RotateYMatrix(float angle);
Matrix RotateZMatrix(float angle);

Matrix ScaleMatrix(float sx, float sy, float sz);
Matrix TranslateMatrix(float dx, float dy, float dz);

Matrix MultMatrixes(Matrix m1, Matrix m2);

Vertex TransformVertex(Vertex vertex, Matrix matrix);

void TransformVertexes(Vertex *vertexes, int count, Matrix matrix);
