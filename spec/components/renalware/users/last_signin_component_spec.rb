describe Renalware::Users::LastSigninComponent, type: :component do
  context "when the user has never logged in" do
    it "renders nothing" do
      user = build_stubbed(:user, last_sign_in_at: nil, current_sign_in_at: nil)
      component = described_class.new(current_user: user)

      render_inline(component).to_html

      expect(page.text).to be_blank
    end
  end

  context "when the user logs in the first time and last_sign_in_at == current_sign_in_at" do
    it "renders nothing" do
      user = build_stubbed(
        :user,
        last_sign_in_at: "2020-10-10 01:01:01",
        current_sign_in_at: "2020-10-10 01:01:01"
      )
      component = described_class.new(current_user: user)

      render_inline(component).to_html

      expect(page.text).to be_blank
    end
  end

  context "when the user has previously signed in" do
    it "renders the last signin date" do
      user = build_stubbed(
        :user,
        last_sign_in_at: "2020-09-09 09:09:09",
        current_sign_in_at: "2020-10-10 01:01:01"
      )
      component = described_class.new(current_user: user)

      render_inline(component).to_html
      expect(page).to have_content("You last signed in at 09:09 on 09-Sep-2020")
    end
  end

  context "when the user failed to sign in" do
    context "when no last signin" do
      it "renders the failed signin attempt" do
        user = build_stubbed(
          :user,
          last_failed_sign_in_at: "2020-09-09 09:09:09",
          current_sign_in_at: "2020-10-10 01:01:01"
        )
        component = described_class.new(current_user: user)

        render_inline(component).to_html
        expect(page).to have_content("You failed to sign in at 09:09 on 09-Sep-2020")
      end
    end

    context "when last signin is the same as current signin" do
      it "renders the failed signin attempt" do
        user = build_stubbed(
          :user,
          last_failed_sign_in_at: "2020-09-09 09:09:09",
          last_sign_in_at: "2020-10-10 01:01:01",
          current_sign_in_at: "2020-10-10 01:01:01"
        )
        component = described_class.new(current_user: user)

        render_inline(component).to_html
        expect(page).to have_content("You failed to sign in at 09:09 on 09-Sep-2020")
      end
    end

    context "when failed signin is more recent than last signin" do
      it "renders the failed signin attempt" do
        user = build_stubbed(
          :user,
          last_failed_sign_in_at: "2020-09-09 09:09:09",
          last_sign_in_at: "2020-09-09 08:09:09",
          current_sign_in_at: "2020-10-10 01:01:01"
        )
        component = described_class.new(current_user: user)

        render_inline(component).to_html
        expect(page).to have_content("You failed to sign in at 09:09 on 09-Sep-2020")
      end
    end

    context "when failed signin is older than last signin" do
      it "renders the last signin attempt (not the failed signin)" do
        user = build_stubbed(
          :user,
          last_failed_sign_in_at: "2020-09-09 09:09:09",
          last_sign_in_at: "2020-09-09 10:09:09",
          current_sign_in_at: "2020-10-10 01:01:01"
        )
        component = described_class.new(current_user: user)

        render_inline(component).to_html
        expect(page).to have_content("You last signed in at 10:09 on 09-Sep-2020")
      end
    end
  end
end
