import React from "react";

export default class Headline extends React.Component {
  render() {
    return (
      <div className="headline-container">
      <h1 className="header">curate your <br></br> digital self</h1>
        <h2 className="subheader">with <span className="blyp-logo">Blyp</span>, you can share your experiences with loved ones</h2>
        
        <div className="temp-button">coming soon to the app store</div>
        
        {/* <div className="download-btn">  
            <a href="" alt="Download in the app store link"> </a>
        </div> */}
            
      </div>
    );
  }
}