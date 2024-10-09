//#pragma pattern_limit 2000000

#include <std/string.pat>

struct Header {
    char magic[4];
    be u32 pof0_addr;
    be u32 unk1 [[color(0x0)]]; // always 0
    be u32 pof0_addr_ ;
    be u32 unk2 [[color(0x0)]]; // always 0
    be u32 unk3 [[color(0x0)]]; // always 0
    be u32 mesh_count;
    be u32 mesh_table_addr;
    be u32 bone_count;
    be u32 tex_count;
    be u32 skel_addr;
    be u32 tex_names;
    be u32 obj_names;
    be u32 obj_count;
    be u32 unk4[4] [[color(0x0)]]; // always 0?
} [[static]];


// TODO: check that it's really ARGB and not RGBA
// Update: probably RGBA!
struct VertexColor {
    char R;
    char G;
    char B;
    char A;
} [[single_color]];

struct Vertex {
    be float pos_x;
    be float pos_y;
    be float pos_z;
    be float normals_x;
    be float normals_y;
    be float normals_z;
    VertexColor color;    
} [[static]];

struct Weight {
    be u32 bone_index;
    be float weight;
} [[static]];

struct TextureUV {
    be float u;
    be float v;
} [[static]];

// name:texDiffuse, data[1] is the offset into the texture table for this mesh
struct Param {
    char name[16];
    be u32 data[2]; // placeholder, can be longer depending on param
} [[static]];

struct ParamIndex {
    be u32 param_addr;
    //Param param @ param_addr + 8;
    char param_name[16] @ param_addr + 8;
    if (std::string::starts_with(param_name, "g_f4")) {
        be u32 unknown_color_param @ param_addr + 24;
        be float srgb[4] @ param_addr + 28;
    } else {
        be u32 unknown_data_param @ param_addr + 24;
        be u32 param_value @ param_addr + 28;
    }    
};


// Triange strip is an optimization to describe multiple triangles that share
// edges

struct TriangleStrip {
    be u32 unknown; // tends to be 6 so maybe type of triangle?
    be u32 face_count; // aligned to 4 bytes and 0 padded at the end
    be u32 face_addr;
    be u16 face[face_count] @ face_addr + 8;
};

struct Mesh {
    be u32 vertex_count [[color(0x00FF00)]];  // must? be under 512
    be u32 triangle_strip_count [[color(0x00FF00)]];
    be u32 bone_count [[color(0x00FF00)]];
    be u32 bones[20]  [[color(0x0000FF)]]; // padded with 0xFF past bone_count entries
    be u32 influence_bone_count;
    be u32 object_id;
    be u32 vertex_buffer_size; // always 1?
    be u32 vertex_buffer_addr; // also marks end of Param section
    be u32 weight_buffer_addr;  // holds 8 bytes * influence_bone_count
    be u32 texture_coordinate_addr; // holds 12 bytes * triangle_strip_count
    be u32 always_1;
    char material_name[12] [[color(0xFF)]];
    be u32 name_params [[color(0xFF)]];
    be u32 unknown1; // Maybe params for material, tend to hold (4,6), (6,6), (6, 7)
    be u32 unknown2; // when material is yBumpMap but can vary for other materials
    be u32 parameter_count;
    be u32 parameter_buffer_addr;
    be u32 triangle_strip_table_addr;
    be u32 weight_count; // same as vertex count so maybe it's something else?
    be u32 always0 [[color(0x0)]];
    // Note the following are little-endian
    le u32 center_x;
    le u32 center_y;
    le u32 center_z;
    le u32 center_origin_distance;    

    ParamIndex param_index[parameter_count] @ parameter_buffer_addr + 8;
    be u32 vertex_buffer @ vertex_buffer_addr + 8;
    Vertex vertex_table[vertex_count] @ vertex_buffer + 8;
    Weight weight_table[weight_count*influence_bone_count] @ weight_buffer_addr + 8;
    TextureUV texture_uv_table[vertex_count] @ texture_coordinate_addr + 8;
    TriangleStrip strips[triangle_strip_count] @ triangle_strip_table_addr + 8;
    // Faces layed out per strip after the strips
};


struct TextureName {
    char name[12] [[color(0xFF)]];
    be u32 params [[color(0xFF)]];
} [[static]];

struct ObjectName {
    char name[12] [[color(0xFF)]];
    be u32 name_params [[color(0xFF)]];
    be u32 unk0; // always 0
    be u32 unk1; // always 1
    be u32 texture_count;
    be u32 unk2; // always 0
} [[static]];

struct Bones {
    char name[12] [[color(0xFF)]];
    be u32 params [[color(0xFF)]];
    be float position[4]; // x, y, z, 0 padding
    be float rotation_radians[4]; // x, y, z, 0 padding
    be u32 parent_bone;
    be u32 pad[3]; // unknown, always 0?
    // Note the following are little-endian
    le u32 center[3]; // x, y, z
    le u32 center_distance; // distance from bone center to origin
} [[static]];

struct Pof0 {
    char magic[4];
    be u32 size;
    char pof0_body[size];
};

struct YOBJ {

    Header header;
    Mesh meshes[header.mesh_count];// @ header.mesh_table_addr + 8;
    // Per-mesh params, vertices, weights, texture UVs, and strips
    // layed out after the meshes
    Bones bones[header.bone_count] @ header.skel_addr + 8;
    TextureName textures[header.tex_count] @ header.tex_names + 8;
    ObjectName objects[header.obj_count] @ header.obj_names + 8;
    Pof0 pof0 @ header.pof0_addr + 8;
};

YOBJ yobj @0x0;