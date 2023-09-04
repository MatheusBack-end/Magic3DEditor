public class Wireframe
{
    private Vector3Buffer vertices;
    private Point3Buffer triangles;
    public float line_width = 0.1f;
    public Vertex w_vertex;
    
    public void make(Vertex vertex)
    {
        NativeIntBuffer triangles_buffer = vertex.getTrianglesBuffer();
        Vector3Buffer vertices_buffer = new Vector3Buffer(vertex.getVerticesBuffer());
        setup_buffers(triangles_buffer.capacity());
        
        for(int i = 0; i < triangles_buffer.capacity() - 1; i += 3)
        {
            draw_line(vertices_buffer.get(triangles_buffer.get(i)), vertices_buffer.get(triangles_buffer.get(i + 1)));
            draw_line(vertices_buffer.get(triangles_buffer.get(i + 1)), vertices_buffer.get(triangles_buffer.get(i + 2)));
            draw_line(vertices_buffer.get(triangles_buffer.get(i + 2)), vertices_buffer.get(triangles_buffer.get(i)));
        }
        
        w_vertex.setVertices(vertices);
        w_vertex.setTriangles(triangles);
    }

    private void draw_line(Vector3 point_a, Vector3 point_b)
    {
        int[] ids = new int[8];
    
        ids[0] = add_vertice(point_a.x + line_width, point_a.y, point_a.z);
        ids[1] = add_vertice(point_a.x - line_width, point_a.y, point_a.z);
        ids[2] = add_vertice(point_a.x, point_a.y + line_width, point_a.z);
        ids[3] = add_vertice(point_a.x, point_a.y - line_width, point_a.z);
        ids[4] = add_vertice(point_b.x + line_width, point_b.y, point_b.z);
        ids[5] = add_vertice(point_b.x - line_width, point_b.y, point_b.z);
        ids[6] = add_vertice(point_b.x, point_b.y + line_width, point_b.z);
        ids[7] = add_vertice(point_b.x, point_b.y - line_width, point_b.z);
        
        triangles.put(ids[0], ids[1], ids[4]);
        triangles.put(ids[1], ids[5], ids[4]);
        triangles.put(ids[4], ids[1], ids[0]);
        triangles.put(ids[4], ids[5], ids[1]);
        triangles.put(ids[2], ids[3], ids[6]);
        triangles.put(ids[3], ids[7], ids[6]);
        triangles.put(ids[6], ids[3], ids[2]);
        triangles.put(ids[6], ids[7], ids[3]);
    }

    private void setup_buffers(int size)
    {
        vertices = BufferUtils.createVector3Buffer(size * 8);
        triangles = BufferUtils.createPoint3Buffer(size * 8);
    }

    private int add_vertice(float x, float y, float z)
    {
        vertices.put(x, y, z);
        return vertices.getPosition() - 1;
    }

    private final int clamp(int min, int max, int value)
    {
        if(value > max)
            return min;
    
        return value;
    }
}
