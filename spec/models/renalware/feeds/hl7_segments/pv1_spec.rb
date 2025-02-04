module Renalware::Feeds::HL7Segments
  describe PV1 do
    subject(:pv1) { Renalware::Feeds::MessageParser.parse(raw_message).pv1 }

    let(:raw_message) do
      <<~RAW
        PV1||O|Clinic1^Name^Desc^RQ8|||||G123456^ROBINSON^BA^^^DR^^^^^^^NATGP|GMC123123^Smith^Francis^^^MR^^^^^^^SDSID|300|||||||||VisitNumber123|||||||||||||||||||||||||||||||||
      RAW
    end

    it "#referring_doctor" do
      expect(pv1.referring_doctor).to have_attributes(
        code: "G123456",
        family_name: "ROBINSON",
        given_name: "BA",
        title: "DR",
        type: "NATGP"
      )
    end

    it "#consulting_doctor" do
      expect(pv1.consulting_doctor).to have_attributes(
        code: "GMC123123",
        family_name: "Smith",
        given_name: "Francis",
        title: "MR",
        type: "SDSID",
        name: "MR Francis Smith"
      )
    end

    it "#clinic (PV1.3)" do # see also assigned_location
      expect(pv1.clinic).to have_attributes(
        code: "Clinic1",
        name: "Name",
        description: "Desc"
      )
    end

    it "#visit_number" do
      expect(pv1.visit_number).to eq("VisitNumber123")
    end

    describe "#assigned_location (PV1.3)" do # see also clinic
      let(:raw_message) do
        <<~RAW
          PV1|1|I|ward^room^bed^facility^loc.stat^BED^building^floor^loc.desc|||""^""^""^""^^^""|Z2736330|||424||||79||||NEWBORN|124301137^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104144000|
        RAW
      end

      it do
        expect(pv1.assigned_location).to have_attributes(
          ward: "ward",
          room: "room",
          bed: "bed",
          facility: "facility",
          location_status: "loc.stat",
          person_location_type: "BED",
          building: "building",
          floor: "floor",
          location_description: "loc.desc"
        )
      end
    end

    describe "#prior_location (PV1.6)" do
      let(:raw_message) do
        <<~RAW
          PV1|1|I|^^^^^^^^|||ward^room^bed^facility^loc.stat^BED^building^floor^loc.desc|Z2736330|||424||||79||||NEWBORN|124301137^^""^^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON|||||20241104144000|
        RAW
      end

      it do
        expect(pv1.prior_location).to have_attributes(
          ward: "ward",
          room: "room",
          bed: "bed",
          facility: "facility",
          location_status: "loc.stat",
          person_location_type: "BED",
          building: "building",
          floor: "floor",
          location_description: "loc.desc"
        )
      end
    end

    describe "#admitted_at (PV1.44)" do
      let(:raw_message) { "PV1|1|||||||||||||||||||||||||||||||||||||||||||20241104144000|" }

      it do
        expect(pv1.admitted_at).to eq(Time.zone.parse("20241104144000"))
      end
    end

    describe "#discharged_at (PV1.45)" do
      let(:raw_message) { "PV1|1||||||||||||||||||||||||||||||||||||||||||||20241104144000" }

      it do
        expect(pv1.discharged_at).to eq(Time.zone.parse("20241104144000"))
      end
    end
  end
end
