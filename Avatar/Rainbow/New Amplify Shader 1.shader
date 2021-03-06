// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snail/Avatar/Rainbow/New Amplify Shader 1"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[Toggle(_MAKEGRAYSCALE_ON)] _MakeGrayscale("Make Grayscale", Float) = 0
		_BaseEmission("Base Emission", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _MAKEGRAYSCALE_ON
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _BaseEmission;


		half3 SH9(  )
		{
			return ShadeSH9(fixed4(0,0,0,1));
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode8_g6 = tex2D( _MainTex, uv_MainTex );
			float3 temp_output_2_0_g6 = (tex2DNode8_g6).rgb;
			float dotResult5_g7 = dot( temp_output_2_0_g6 , float3(0.3,0.59,0.11) );
			float temp_output_10_0_g6 = dotResult5_g7;
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g6 = (temp_output_10_0_g6).xxx;
			#else
				float3 staticSwitch5_g6 = temp_output_2_0_g6;
			#endif
			float4 color12 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 Color11 = color12;
			float4 temp_output_5_0 = ( float4( staticSwitch5_g6 , 0.0 ) * Color11 );
			half3 localSH98_g49 = SH9();
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			c.rgb = ( temp_output_5_0 * float4( ( localSH98_g49 + (( ase_lightColor.rgb * ase_lightAtten )).xyz ) , 0.0 ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode8_g6 = tex2D( _MainTex, uv_MainTex );
			float3 temp_output_2_0_g6 = (tex2DNode8_g6).rgb;
			float dotResult5_g7 = dot( temp_output_2_0_g6 , float3(0.3,0.59,0.11) );
			float temp_output_10_0_g6 = dotResult5_g7;
			float4 color12 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 Emission10 = color12;
			#ifdef _MAKEGRAYSCALE_ON
				float3 staticSwitch5_g6 = (temp_output_10_0_g6).xxx;
			#else
				float3 staticSwitch5_g6 = temp_output_2_0_g6;
			#endif
			float4 Color11 = color12;
			float4 temp_output_5_0 = ( float4( staticSwitch5_g6 , 0.0 ) * Color11 );
			o.Emission = ( (temp_output_10_0_g6*_BaseEmission + Emission10.r) * temp_output_5_0 ).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
1927;29;1906;1004;1653.307;335.507;1;True;False
Node;AmplifyShaderEditor.ColorNode;12;-1234.307,143.493;Float;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-841.9482,225.6373;Float;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-858.5844,-68.57323;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-628.4821,13.84421;Float;False;Property;_BaseEmission;Base Emission;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1;-605.0358,228.6224;Float;False;11;Color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2;-628.8862,-65.86884;Float;False;10;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;3;-608.9711,102.8082;Float;False;MainTex;3;;6;45db3e40c3069804caaf81bcab512992;0;0;3;FLOAT;11;FLOAT;9;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-300.21,115.7728;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;7;-407.6038,294.1347;Float;False;FlatLighting;0;;49;fc517e88685f04d45a66f4bd14b48aba;1,27,0;4;30;FLOAT;1;False;25;FLOAT3;0,0,0;False;22;FLOAT;0;False;20;SAMPLER2D;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;6;-368.4818,-9.855766;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-152.3621,227.6395;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-150.3379,46.39619;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;snail/Avatar/Rainbow/New Amplify Shader 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;12;0
WireConnection;10;0;12;0
WireConnection;5;0;3;0
WireConnection;5;1;1;0
WireConnection;6;0;3;11
WireConnection;6;1;4;0
WireConnection;6;2;2;0
WireConnection;9;0;5;0
WireConnection;9;1;7;0
WireConnection;8;0;6;0
WireConnection;8;1;5;0
WireConnection;0;2;8;0
WireConnection;0;13;9;0
ASEEND*/
//CHKSM=B57AA916C0FE3B286ED79AD69D2DF2CCE7C4B0F2