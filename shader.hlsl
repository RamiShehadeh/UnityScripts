Shader "Custom/HeightBasedTransparency" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _TransparencyThreshold ("Transparency Threshold", Float) = 0.0
        _MinAlpha ("Minimum Alpha", Range(0,1)) = 0.2
    }
    SubShader {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade

        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
        };

        sampler2D _MainTex;
        fixed4 _Color;
        float _TransparencyThreshold;
        float _MinAlpha;

        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Apply texture and tint color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            // Compute transparency
            // Use smooth interpolation between full opacity and minimum alpha
            float alpha = IN.worldPos.y > _TransparencyThreshold ? 1.0 : lerp(_MinAlpha, 1.0, (IN.worldPos.y / _TransparencyThreshold));

            // Apply computed transparency
            c.a *= alpha;

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
