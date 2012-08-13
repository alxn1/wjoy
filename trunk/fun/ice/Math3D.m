//
//  Math3D.m
//  ice
//
//  Created by alxn1 on 26.09.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "Math3D.h"

Matrix IdentityMatrix(void)
{
    Matrix result =
    {
        1.0f, 0.0f, 0.0f, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f,
    };

    return result;
}

Matrix RotateXMatrix(float angle)
{
    angle   = (angle * M_PI) / 180.0f;
    float s = sinf(angle);
    float c = cosf(angle);

    Matrix result =
    {
        1.0f, 0.0f, 0.0f, 0.0f,
        0.0f,    c,   -s, 0.0f,
        0.0f,    s,    c, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f
    };

    return result;
}

Matrix RotateYMatrix(float angle)
{
    angle   = (angle * M_PI) / 180.0f;
    float s = sinf(angle);
    float c = cosf(angle);

    Matrix result =
    {
           c, 0.0f,    s, 0.0f,
        0.0f, 1.0f, 0.0f, 0.0f,
          -s, 0.0f,    c, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f
    };

    return result;
}

Matrix RotateZMatrix(float angle)
{
    angle   = (angle * M_PI) / 180.0f;
    float s = sinf(angle);
    float c = cosf(angle);

    Matrix result =
    {
           c,   -s, 0.0f, 0.0f,
           s,    c, 0.0f, 0.0f,
        0.0f, 0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, 0.0f, 1.0f
    };

    return result;
}

Matrix ScaleMatrix(float sx, float sy, float sz)
{
    Matrix result =
    {
        sx,   0.0f, 0.0f, 0.0f,
        0.0f, sy,   0.0f, 0.0f,
        0.0f, 0.0f, sz,   0.0f,
        0.0f, 0.0f, 0.0f, 1.0f
    };

    return result;
}

Matrix TranslateMatrix(float dx, float dy, float dz)
{
    Matrix result =
    {
        1.0f, 0.0f, 0.0f, dx,
        0.0f, 1.0f, 0.0f, dy,
        0.0f, 0.0f, 1.0f, dz,
        0.0f, 0.0f, 0.0f, 1.0f
    };

    return result;
}

Matrix MultMatrixes(Matrix m1, Matrix m2)
{
    Matrix result =
    {
        m1.a11 * m2.a11 + m1.a21 * m2.a12 + m1.a31 * m2.a13 + m1.a41 * m2.a14,
        m1.a11 * m2.a21 + m1.a21 * m2.a22 + m1.a31 * m2.a23 + m1.a41 * m2.a24,
        m1.a11 * m2.a31 + m1.a21 * m2.a32 + m1.a31 * m2.a33 + m1.a41 * m2.a34,
        m1.a11 * m2.a41 + m1.a21 * m2.a42 + m1.a31 * m2.a43 + m1.a41 * m2.a44,

        m1.a12 * m2.a11 + m1.a22 * m2.a12 + m1.a32 * m2.a13 + m1.a42 * m2.a14,
        m1.a12 * m2.a21 + m1.a22 * m2.a22 + m1.a32 * m2.a23 + m1.a42 * m2.a24,
        m1.a12 * m2.a31 + m1.a22 * m2.a32 + m1.a32 * m2.a33 + m1.a42 * m2.a34,
        m1.a12 * m2.a41 + m1.a22 * m2.a42 + m1.a32 * m2.a43 + m1.a42 * m2.a44,

        m1.a13 * m2.a11 + m1.a23 * m2.a12 + m1.a33 * m2.a13 + m1.a43 * m2.a14,
        m1.a13 * m2.a21 + m1.a23 * m2.a22 + m1.a33 * m2.a23 + m1.a43 * m2.a24,
        m1.a13 * m2.a31 + m1.a23 * m2.a32 + m1.a33 * m2.a33 + m1.a43 * m2.a34,
        m1.a13 * m2.a41 + m1.a23 * m2.a42 + m1.a33 * m2.a43 + m1.a43 * m2.a44,

        m1.a14 * m2.a11 + m1.a24 * m2.a12 + m1.a34 * m2.a13 + m1.a44 * m2.a14,
        m1.a14 * m2.a21 + m1.a24 * m2.a22 + m1.a34 * m2.a23 + m1.a44 * m2.a24,
        m1.a14 * m2.a31 + m1.a24 * m2.a32 + m1.a34 * m2.a33 + m1.a44 * m2.a34,
        m1.a14 * m2.a41 + m1.a24 * m2.a42 + m1.a34 * m2.a43 + m1.a44 * m2.a44,
    };

    return result;
}

Vertex TransformVertex(Vertex vertex, Matrix matrix)
{
    Vertex result = vertex;

    result.x = matrix.a11 * vertex.x + matrix.a21 * vertex.y + matrix.a31 * vertex.z + matrix.a41;
    result.y = matrix.a12 * vertex.x + matrix.a22 * vertex.y + matrix.a32 * vertex.z + matrix.a42;
    result.z = matrix.a13 * vertex.x + matrix.a23 * vertex.y + matrix.a33 * vertex.z + matrix.a43;

    return result;
}

void TransformVertexes(Vertex *vertexes, int count, Matrix matrix)
{
    if( vertexes == NULL )
        return;

    for(int i = 0; i < count; i++)
    {
        Vertex result = vertexes[i];

        result.x = matrix.a11 * vertexes[i].x + matrix.a21 * vertexes[i].y + matrix.a31 * vertexes[i].z + matrix.a41;
        result.y = matrix.a12 * vertexes[i].x + matrix.a22 * vertexes[i].y + matrix.a32 * vertexes[i].z + matrix.a42;
        result.z = matrix.a13 * vertexes[i].x + matrix.a23 * vertexes[i].y + matrix.a33 * vertexes[i].z + matrix.a43;

        vertexes[ i ] = result;
    }
}
