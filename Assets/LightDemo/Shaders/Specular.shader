shader "Demo/Specular"
{
	properties
	{
		//_maintex ("texture", 2d) = "white" {}
		_Diffuse ("diffuse", color) = (1, 1, 1, 1)
		_Specular ("specular", color) = (1, 1, 1, 1)
		_Gloss ("gloss",  range(8.0, 256.0)) = 20 
	}
	subshader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			//#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				//fixed3 worldnormal : texcoord0;
				fixed3 color: COLOR;
			};

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				float3 worldnormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				fixed3 worldlightdir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldnormal, worldlightdir));
				fixed3 reflectDir = normalize(reflect(-worldlightdir, worldnormal));
				fixed3 viewdir = normalize(_WorldSpaceLightPos0.xyz - mul(v.vertex, unity_WorldToObject).xyz);
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(reflectDir, viewdir)), _Gloss);
				o.color = ambient + diffuse + specular;
				//o.color = diffuse;
				//o.worldnormal = mul(v.normal, (float3x3)unity_worldtoobject);
				return o;
			}
			
			// reflect = 2*(n*i)n-i;
			fixed4 frag (v2f i) : sv_target 
			{
			/*
				fixed3 ambient = unity_lightmodel_ambient.xyz;
				fixed3 worldnormal = normalize(i.worldnormal);
				fixed3 worldlightdir = normalize(_worldspacelightpos0.xyz);
				fixed3 diffuse = _lightcolor0.rgb * _diffuse.rgb * saturate(dot(worldnormal, worldlightdir));
				fixed3 color = ambient + diffuse;
			*/
				return fixed4(i.color, 1.0);
			}
			ENDCG
		}
	}
}
