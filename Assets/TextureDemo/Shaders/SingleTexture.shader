shader "Demo/SingleTexture"
{
	properties
	{
		_MainTex ("texture", 2D) = "white" {}
		_Color ("color", color) = (1, 1, 1, 1)
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
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members uv)
#pragma exclude_renderers d3d11

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
				float4 texcoord : TEXCOORD0;

			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 worldnormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			fixed4 _Specular;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 worldnormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				o.worldnormal = worldnormal;
				o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				//o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			// reflect = 2*(n*i)n-i;
			fixed4 frag (v2f i) : sv_target 
			{
				fixed3 worldNormal = normalize(i.worldnormal);
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 diffuse = _LightColor0.rgb * albedo.rgb * saturate(dot(worldNormal, worldLightDir));
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
				fixed3 color = ambient + diffuse + specular;
				return fixed4(color, 1.0);
			}
			ENDCG
		}
	}
}
