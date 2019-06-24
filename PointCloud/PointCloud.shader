// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "snail/PointCloud/PointCloud" 
{
    Properties 
    {
		// Super handy guide for prettier properties!
		// https://gist.github.com/keijiro/22cba09c369e27734011
		_MainTex("Texture", 2D) = "white" {}
    	_GRID_SIZE("Grid Size", Float) = .1
    	_SCALE("_SCALE", Float) = 1
    	_DIST("Dist", Float) = 1
    	_ITER_SCALE("Iter scale", Float) = 1
    	_FILL("Fill", Range(0,1)) = 1

    }

    SubShader 
    {
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
		}
    	CGINCLUDE
    		#include "UnityCG.cginc"
    		#include "../ShaderUtils/Inlines.cginc"
    		#include "../ShaderUtils/Noise2.cginc"
    		uniform float _GRID_SIZE;
    		uniform float _DIST;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _ITER_SCALE;
			uniform float _SCALE;
			uniform float _FILL;
    	ENDCG

    	Pass {
	        ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
            	#pragma shader_feature DEBUGGING
            	#pragma shader_feature SCALE_PROPORTIONAL

				struct VS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
			    	float3 normal : NORMAL;
				};
				struct GS_INPUT { 
					float4 vertex : POSITION; 
					float4 uv : TEXCOORD0;
			    	float3 normal : NORMAL;
				};
				struct FS_INPUT { 
					float4 vertex : POSITION;
					float4 uv : TEXCOORD0;
					// uv.w is tranpancy
				};


				// Mostly passthrough shader.
				// I do want all the verticies in world space (not clip yet).
				#pragma vertex VS_Main
				GS_INPUT VS_Main(VS_INPUT input)
				{
					GS_INPUT output = (GS_INPUT)0;
					output.vertex =  input.vertex;
					output.normal = input.normal;
					output.uv = input.uv;
				//	output.color = input.color;
					return output;
				}

				inline void doPoint(inout FS_INPUT io, float3 pos, float3 center) {
					float v = 1;
					float scroll =-.2;
					v *= snoise(float4(pos*_SCALE*20-float3(0,scroll*_Time.y,0), _Time.y/2));
					v *= v;
					v *= v;
					//v *= v;
					io.uv.w = v;
					io.uv.x = v;
				}
				// Put an edge in the output stream
				inline void edge(
						float3 objPos, 
						float3 edgeDir, 
						inout LineStream<FS_INPUT> stream) {

					FS_INPUT output = (FS_INPUT) 0;
					float4 center = mul(unity_ObjectToWorld, float4(0,0,0,1));
					float4 start = mul(unity_ObjectToWorld, float4(objPos,1));
					float4 end = mul(unity_ObjectToWorld, float4(objPos+edgeDir,1));


					doPoint(output, start + edgeDir*100, center + edgeDir*100);
					output.vertex = mul(UNITY_MATRIX_VP, start);
					stream.Append(output);

					doPoint(output, end + edgeDir*100, center + edgeDir*100);
					output.vertex = mul(UNITY_MATRIX_VP, end);
					stream.Append(output);
					stream.RestartStrip();
				}

				#pragma geometry GS_Main
				[maxvertexcount(6)] 
				void GS_Main(point GS_INPUT input[1], 
							 uint pid : SV_PrimitiveID, 
							 inout LineStream<FS_INPUT> stream) {
					FS_INPUT output = (FS_INPUT) 0;
					//float3 vertex = input[0].vertex;

					int size = 40;
					float3 offset = float3(size/2, size/2, size/2)*_SCALE;
					float3 vertex = float3(
						pid%size,
						pid/size%size,
						pid/size/size%size
					) * _SCALE;

					if(vertex.x < size-1) edge(vertex-offset, float3(1,0,0)*_SCALE, stream);
					if(vertex.y < size-1) edge(vertex-offset, float3(0,1,0)*_SCALE, stream);
					if(vertex.z < size-1) edge(vertex-offset, float3(0,0,1)*_SCALE, stream);					
				}

				
                #pragma fragment FS_Main
				float4 FS_Main(FS_INPUT input) : COLOR
				{
					float4 o = tex2D(_MainTex, input.uv.xx);
					o.a *= abs(input.uv.w);
					return o;
				}
			ENDCG
		}
    } 
}
