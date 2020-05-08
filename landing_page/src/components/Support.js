import React from "react";
import SupportLink from "./SupportLink";

export default class Support extends React.Component {
    render() {
        return (
            <div id="support" className="section support">
                <h2 className="">how can you support?</h2>

                <SupportLink
                    title={"take our survey"}
                    details="We'd appreciate you taking our anonymous Google form about your general experiences regarding passing and loss. The survey takes about 5-10 minutes."
                    buttonName="general survey"
                    buttonHref="https://forms.gle/syDWc5oLZiQ3mnwa9"
                ></SupportLink>

                <SupportLink
                    title={"interview with us"}
                    details="If you have worked with those at end of life, are preparing for end of life, or are preparing to lose a loved one, we would love to interview you!"
                    buttonName="interview sign up"
                    buttonHref="https://forms.gle/Kw2JkxV8DnjjL1q46"
                ></SupportLink>

            </div>
        );
    }
}
