Shader "Custom/HeightBasedTransparency" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _TransparencyThreshold ("Transparency Threshold", Float) = 0.0
    }
    SubShader {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade

        // Define the structure used to communicate with the shader.
        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
        };

        sampler2D _MainTex;
        fixed4 _Color;
        float _TransparencyThreshold;

        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Apply texture and tint color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            
            // Compute transparency based on the y-coordinate of world position
            float alpha = step(_TransparencyThreshold, IN.worldPos.y);
            c.a *= alpha;  // Apply computed transparency

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
