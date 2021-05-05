<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
		xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
		xmlns="http://www.opengis.net/sld"
		xmlns:ogc="http://www.opengis.net/ogc"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<!-- a named layer is the basic building block of an sld document -->

	<NamedLayer>
		<Name>Biogeo outline</Name>
		<UserStyle>
			<Title>Black Line</Title>
          <Abstract>Black line</Abstract>
			<FeatureTypeStyle>
				<Rule>
					<Name>Rule 1</Name>
					<Title>Black Line</Title>
					<Abstract>A black line with a 1 pixel width</Abstract>
					<LineSymbolizer>
						<Stroke>
							<CssParameter name="stroke">#000000</CssParameter>
						</Stroke>
					</LineSymbolizer>
				</Rule>

		    </FeatureTypeStyle>
		</UserStyle>
	</NamedLayer>
</StyledLayerDescriptor>