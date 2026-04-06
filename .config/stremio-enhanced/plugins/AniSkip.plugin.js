"use strict";
/**
* @name AniSkip
* @description Integrates AniSkip to Stremio Enhanced to skip anime openings and endings (Only works with kitsu). Please note that this is still expiremental.
* @updateUrl https://raw.githubusercontent.com/REVENGE977/stremio-aniskip/main/dist/AniSkip.plugin.js
* @version 1.0.0
* @author REVENGE977
*/
if (localStorage.getItem("aniskip_userid") == null) {
    localStorage.setItem("aniskip_userid", crypto.randomUUID());
}
async function hashChangeHandler() {
    if (!location.hash.startsWith("#/player"))
        return;
    console.log("AniSkip: Player opened");
    let playerState = (await getPlayerState());
    let currentEpisodeInfo = playerState.seriesInfoDetails;
    let metaInfo = playerState.metaDetails;
    let isKitsu = metaInfo.id.startsWith("kitsu:");
    if (!isKitsu)
        return console.log("AniSkip: Not using Kitsu metadata. AniSkip plugin not supported.");
    createAniSkipButton();
    let showName = metaInfo.name;
    // let year = metaInfo.releaseInfo.split("-")[0].split('–')[0];
    let episodeNumber = currentEpisodeInfo.episode;
    let MAL = await fetchJikan(showName);
    if (MAL) {
        console.log("AniSkip: Found myanimelist anime ID: " + MAL);
        let aniskip = await AniSkip.getSkipTimes(MAL, episodeNumber);
        if (aniskip.found) {
            aniskip.results.forEach((segment) => {
                let timestampStart = segment.interval.start_time;
                let timestampEnd = segment.interval.end_time;
                let segmentType = segment.skip_type;
                let segmentId = segment.skip_id;
                console.log(`AniSkip: Found ${segmentType} skip times (${segmentId}) for episode ${episodeNumber} of ${showName} at ${timestampStart} - ${timestampEnd}`);
                createSkipPopup(timestampStart, timestampEnd, segmentType);
                addLayerToPlayer(timestampStart, timestampEnd, segmentType);
            });
        }
        else {
            console.log("AniSkip: No skip times found in AniSkip database.");
            AniSkip.skipTimes = null;
        }
    }
    else {
        console.log("AniSkip: No matching anime or episode found.");
    }
}
class AniSkip {
    static API_URL = 'https://api.aniskip.com/v1';
    static skipTimes = null;
    static async getSkipTimes(malId, episode) {
        let req = await fetch(`${this.API_URL}/skip-times/${malId}/${episode}?types=op&types=ed`);
        let data = await req.json();
        if (data.found)
            this.skipTimes = data;
        return data;
    }
    static async vote(segmentId, type) {
        let req = await fetch(`${this.API_URL}/skip-times/vote/${segmentId}`, {
            method: 'POST',
            body: JSON.stringify({
                vote_type: type
            }),
            headers: {
                'Content-Type': 'application/json'
            }
        });
        let res = req.status;
        if (res == 429)
            return console.log("AniSkip: Rate limited. Please try again later.");
        return req.json();
    }
    static async createSkipTimes(animeId, episodeNumber, skipType, startTime, endTime, episodeLength, submitterId) {
        let req = await fetch(`${this.API_URL}/skip-times/${animeId}/${episodeNumber}`, {
            method: 'POST',
            body: JSON.stringify({
                skip_type: skipType,
                provider_name: "stremio",
                start_time: startTime,
                end_time: endTime,
                episode_length: episodeLength,
                submitter_id: submitterId
            }),
            headers: {
                'Content-Type': 'application/json'
            }
        });
        let res = req.status;
        if (res == 429)
            return console.log("AniSkip: Rate limited. Please try again later.");
        return req.json();
    }
}
// async function fetchMAL(title: string, startYear:number) {
//     console.log(`AniSkip: Searching for ${title} on MyAnimeList`);
//     let combinedTitle = encodeWithPlus(title);
//     let req = await fetch(`https://myanimelist.net/search/prefix.json?type=anime&keyword=${combinedTitle}`);
//     let data:any = await req.json();
//     const animeCategory = data.categories.find((cat: any) => cat.type === 'anime');
//     if (!animeCategory) return console.log('AniSkip: No anime results found.');
//     if (animeCategory.items.length === 0) return console.log('AniSkip: No anime results found.');
//     const filteredItems = animeCategory.items.filter((item: any) => item.payload.media_type === 'TV');
//     if (filteredItems.length === 0) return console.log('AniSkip: No TV anime results found.');
//     console.log("Current title year of release is: " + startYear + " & year found in MAL title result is: " + filteredItems[0].payload.start_year);
//     if(compareTitlesBySimilarity(title, filteredItems[0].name, 30) && filteredItems[0].payload.start_year == startYear) {
//         return filteredItems[0].id
//     }
//     return null;
// }
// fetch Jikan API to find the anime ID in MyAnimeList. This is good because Kitsu uses English titles instead of Japanese titles and Jikan supports both.
async function fetchJikan(title) {
    console.log(`AniSkip: Searching for ${title} on Jikan`);
    let combinedTitle = encodeWithPlus(title);
    let req = await fetch(`https://api.jikan.moe/v4/anime?q=${combinedTitle}&limit=1`);
    let res = await req.json();
    if (res.pagination.items.count == 0)
        return console.log('AniSkip: No anime results found.');
    if (res.data.length == 0)
        return console.log('AniSkip: No anime results found.');
    return res.data[0].mal_id;
}
window.addEventListener('hashchange', hashChangeHandler);
window.addEventListener('load', hashChangeHandler);
const skipPopupHTML = `
<div class="layer-qalDW menu-layer-HZFG9 next-video-popup-container-H4wnL">
  <div class="info-container-KLOMx">
    <div class="details-container-bUOTZ">
      <div class="name-sIiDL">
        <span class="label-zOq_w">Skip {{ textType }}?</span>
      </div>
      <div class="title-Z5Kgo">This will skip to {{ timestamp }} (Autoskipping in 5s)</div>
    </div>
    <div class="buttons-container-iYrpZ">
      <div tabindex="0" class="button-container-i4F7t dismiss-IvEL_ button-container-zVLH6" id="dismiss-{{ type }}-button">
        <svg class="icon-N3Ewm" viewBox="0 0 512 512"><path d="M289.90000000000146 256l95-95c4.5-4.53 7-10.63 7.1-17 0-6.38-2.5-12.5-7-17.02s-10.6-7.07-17-7.08c-3.2-0.01-6.3 0.61-9.2 1.81s-5.6 2.96-7.8 5.19l-95 95-95-95c-3.4-3.33-7.6-5.6-12.3-6.51-4.6-0.91-9.4-0.42-13.8 1.4-4.4 1.79-8.1 4.86-10.8 8.81-2.6 3.94-4 8.58-4 13.33-0.1 3.15 0.5 6.28 1.7 9.19 1.2 2.92 3 5.57 5.2 7.78l95 95-95 95c-2.8 2.8-4.8 6.24-6 10.02-1.1 3.78-1.3 7.78-0.5 11.64 0.8 3.87 2.5 7.48 5 10.52 2.5 3.05 5.8 5.43 9.4 6.93 4.4 1.81 9.2 2.29 13.8 1.39 4.7-0.91 8.9-3.17 12.3-6.5l95-95 95 95c3.4 3.34 7.6 5.6 12.3 6.51 4.6 0.92 9.4 0.43 13.8-1.39 4.4-1.8 8.1-4.87 10.8-8.82 2.6-3.94 4-8.58 4-13.33 0.1-3.15-0.5-6.28-1.7-9.2-1.2-2.91-3-5.56-5.2-7.77z" style="fill: currentcolor;"></path></svg>
        <div class="label-zOq_w">Dismiss</div>
      </div>
      <div tabindex="0" class="button-container-i4F7t play-button-Dluk6 button-container-zVLH6" id="skip-{{ type }}-button">
        <svg class="icon-N3Ewm" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><title>Skip</title><path d="M13,6V18L21.5,12M4,18L12.5,12L4,6V18Z" style="fill: currentcolor;" /></svg>
        <div class="label-zOq_w">Skip</div>
      </div>
    </div>
  </div>
</div>
`;
const controlBarButtonHTML = `
<div tabindex="-1" class="control-bar-button-FQUsj button-container-zVLH6">
    <svg class='icon-qy6I6' xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><title>AniSkip</title><path d="M13,6V18L21.5,12M4,18L12.5,12L4,6V18Z" style="fill: currentcolor;" /></svg>
</div>
`;
const aniSkipPopupHTML = `
<div class="layer-qalDW menu-layer-HZFG9 subtitles-menu-container-PxBRZ" id="aniskip-popup">

  <div class="variants-container-XglzH">
    <div class="variants-header-TsVSR">AniSkip Segments</div>

    <div class="variants-list-yZo6B" id="aniskip-segments-list">

    </div>
  </div>

  <div class="subtitles-settings-container-LhRGS">
    <div class="settings-header-eaWnm">Submit New Segment</div>
    <div class="settings-list-mhZV6">

      <div class="discrete-input-fXELp discrete-input-container-CMThy">
        <div class="header-n0jWL">Type</div>
        <div class="input-container-TNuI2">
          <select class="option-label-tjeeT" id="type-select">
            <option>Opening</option>
            <option>Ending</option>
          </select>
        </div>
      </div>

      <div class="discrete-input-fXELp discrete-input-container-CMThy">
        <div class="header-n0jWL">Start Time</div>
        <div class="input-container-TNuI2">
            <input class="option-label-tjeeT" type="text" placeholder="e.g. 00:00" id="starttime-input" />
            <div tabindex="0" class="option-container-m_jZq button-container-zVLH6" id="current-starttimestamp-btn">
                <div class="label-cmqqu">Now</div>
            </div>
        </div>
      </div>

      <div class="discrete-input-fXELp discrete-input-container-CMThy">
        <div class="header-n0jWL">End Time</div>
        <div class="input-container-TNuI2">
            <input class="option-label-tjeeT" type="text" placeholder="e.g. 01:30" id="endtime-input" />
            <div tabindex="0" class="option-container-m_jZq button-container-zVLH6" id="current-endtimestamp-btn">
                <div class="label-cmqqu">Now</div>
            </div>
        </div>
      </div>

      <div class="discrete-input-fXELp discrete-input-container-CMThy">
        <div tabindex="0" class="option-container-m_jZq button-container-zVLH6" id="aniskip-submit-button">
          <div class="label-cmqqu">➕ Submit Segment</div>
        </div>
      </div>

    </div>
  </div>

</div>
`;
const segmentHTML = `
<div class="variant-option-t7_LA selected button-container-zVLH6" style="display: flex; justify-content: space-between; align-items: center;">
    <div class="info-mxjJh">
        <div class="variant-label-opjnP"><b>{{ segmentType }}</b></div>
        <div class="variant-label-opjnP" style="font-size: 14px;">{{ timestampStart }} - {{ timestampEnd }}</div>
    </div>

    <div style="display: flex; flex-direction: column; gap: 4px; justify-content: center;">
        <div tabindex="0" class="button-container-zVLH6" style="display: flex; flex-direction: row; align-items: center;" id="aniskip-upvote-{{ id }}">
            <div class="label-cmqqu">🔼</div>
        </div>
        <div tabindex="0" class="button-container-zVLH6" style="display: flex; flex-direction: row; align-items: center;" id="aniskip-downvote-{{ id }}">
            <div class="label-cmqqu">🔽</div>
        </div>
    </div>
</div>
`;
function addLayerToPlayer(start, end, type = "op") {
    let video = document.getElementsByTagName("video")[0];
    if (video.readyState >= 4) {
        addSegmentLayer(start, end, type);
    }
    else {
        video.addEventListener('canplay', function () {
            addSegmentLayer(start, end, type);
        });
    }
}
function addSegmentLayer(start, end, type = "op") {
    if (document.getElementById(`${type}-layer`)) {
        document.getElementById(`${type}-layerDiv`)?.remove();
        document.getElementById(`${type}-layer`)?.remove();
    }
    let slider = document.querySelector(".slider-hBDOf");
    let segmentData = calculateSlider(start, end);
    const computedStyle = getComputedStyle(slider);
    console.log(`AniSkip: Adding ${type} layer to player ${segmentData?.width} ${segmentData?.marginLeft}`);
    const trackSize = computedStyle.getPropertyValue('--track-size').trim();
    let layerDiv = document.createElement("div");
    layerDiv.classList.add("layer-aC5Vt");
    layerDiv.id = `${type}-layerDiv`;
    let segmentLayer = document.createElement("div");
    segmentLayer.style.width = `calc(${segmentData?.width})`;
    segmentLayer.style.marginLeft = `calc(${segmentData?.marginLeft})`;
    segmentLayer.style.background = "rgba(251, 255, 0, 0.78)";
    segmentLayer.style.height = trackSize;
    segmentLayer.style.position = "absolute";
    segmentLayer.style.borderRadius = "3px";
    segmentLayer.classList.add("track-after-pUXC0");
    segmentLayer.id = `${type}-layer`;
    layerDiv.appendChild(segmentLayer);
    let third = slider?.children[2];
    if (third?.nextSibling) {
        slider?.insertBefore(layerDiv, third.nextSibling);
    }
    else {
        slider?.appendChild(layerDiv);
    }
}
// Creates the button that opens the menu in which the user can vote the skip segment or create new ones
function createAniSkipButton() {
    let controlBar = document.querySelector('.control-bar-buttons-menu-container-M6L0_');
    let aniSkipButton = document.createElement('div');
    aniSkipButton.innerHTML = controlBarButtonHTML;
    aniSkipButton.id = "aniskip-controlbar-button";
    controlBar.insertBefore(aniSkipButton, controlBar.firstChild);
    createAniSkipPopup();
}
function createAniSkipPopup() {
    const aniSkipButton = document.getElementById("aniskip-controlbar-button");
    aniSkipButton.addEventListener('click', async () => {
        const playerControl = document.querySelector('.player-container-wIELK');
        if (document.getElementById("aniskip-popup")) {
            document.getElementById("aniskip-popup")?.remove();
        }
        else {
            let aniSkipPopup = document.createElement('div');
            aniSkipPopup.innerHTML = aniSkipPopupHTML;
            aniSkipPopup.id = "aniskip-popup";
            playerControl.appendChild(aniSkipPopup);
            let getSkipTimes = AniSkip.skipTimes;
            if (getSkipTimes != null) {
                getSkipTimes.results.forEach((segment) => {
                    let timestampStart = segment.interval.start_time;
                    let timestampEnd = segment.interval.end_time;
                    let segmentType = segment.skip_type;
                    let segmentId = segment.skip_id;
                    let segmentDiv = segmentHTML
                        .replace("{{ segmentType }}", segmentType == "op" ? "Opening" : "Ending")
                        .replace("{{ timestampStart }}", convertSecondsToMMSSMS(timestampStart))
                        .replace("{{ timestampEnd }}", convertSecondsToMMSSMS(timestampEnd))
                        .replace("{{ id }}", segmentId.toString());
                    document.getElementById("aniskip-segments-list")?.insertAdjacentHTML("beforeend", segmentDiv);
                    document.getElementById(`aniskip-upvote-${segmentId}`)?.addEventListener('click', async () => {
                        console.log(`AniSkip: Upvoted segment ${segmentId}`);
                        let res = await AniSkip.vote(segmentId, "upvote");
                        if (res.message == "success")
                            alert("AniSkip: Successfully upvoted segment! skip_id: " + segmentId);
                        else
                            alert("AniSkip: Failed to upvote segment. Reason: " + res.message);
                    });
                    document.getElementById(`aniskip-downvote-${segmentId}`)?.addEventListener('click', async () => {
                        console.log(`AniSkip: Downvoted segment ${segmentId}`);
                        await AniSkip.vote(segmentId, "downvote");
                        let res = await AniSkip.vote(segmentId, "downvote");
                        if (res.message == "success")
                            alert("AniSkip: Successfully downvoted segment! skip_id: " + segmentId);
                        else
                            alert("AniSkip: Failed to downvote segment. Reason: " + res.message);
                    });
                });
            }
            document.getElementById(`aniskip-submit-button`)?.addEventListener('click', async () => {
                let startTimeInput = document.getElementById("starttime-input");
                let endTimeInput = document.getElementById("endtime-input");
                let typeSelect = document.getElementById("type-select");
                let typeValue = typeSelect.value == "Opening" ? "op" : "ed";
                let episodeLength = document.querySelector('video').duration;
                let playerState = (await getPlayerState());
                let currentEpisodeInfo = playerState.seriesInfoDetails;
                let metaInfo = playerState.metaDetails;
                let showName = metaInfo.name;
                let episodeNumber = currentEpisodeInfo.episode;
                let MAL = await fetchJikan(showName);
                if (!MAL)
                    return console.log("AniSkip: No matching anime found.");
                let startTime = startTimeInput.value.split(":")
                    .map(Number)
                    .reduce((acc, time, index) => {
                    return index === 2 ? acc + (time / 1000) : (60 * acc) + time;
                }, 0);
                let endTime = endTimeInput.value.split(":")
                    .map(Number)
                    .reduce((acc, time, index) => {
                    return index === 2 ? acc + (time / 1000) : (60 * acc) + time;
                }, 0);
                console.log(`AniSkip: Submitting new segment ${typeValue} ${startTime} - ${endTime}`);
                let res = await AniSkip.createSkipTimes(MAL, episodeNumber, typeValue, startTime, endTime, episodeLength, localStorage.getItem("aniskip_userid"));
                if (res.message == "success") {
                    alert("AniSkip: Successfully submitted new segment! skip_id: " + res.skip_id);
                }
                else
                    alert("AniSkip: Failed to submit new segment. Reason: " + res.message);
            });
            document.getElementById("current-starttimestamp-btn")?.addEventListener('click', () => {
                let video = document.querySelector('video');
                if (video) {
                    let currentTime = video.currentTime;
                    let formattedTime = convertSecondsToMMSSMS(currentTime);
                    document.getElementById("starttime-input").value = formattedTime;
                }
            });
            document.getElementById("current-endtimestamp-btn")?.addEventListener('click', () => {
                let video = document.querySelector('video');
                if (video) {
                    let currentTime = video.currentTime;
                    let formattedTime = convertSecondsToMMSSMS(currentTime);
                    document.getElementById("endtime-input").value = formattedTime;
                }
            });
        }
    });
}
// Creates the skip popup for the user to interact with
async function createSkipPopup(start, end, type = "op") {
    if (document.getElementById(`skip-${type}-button`))
        document.getElementById(`skip-${type}-button`)?.remove();
    let playerContainer = document.querySelector('.player-container-wIELK');
    let skipContainer = document.createElement('div');
    skipContainer.style.display = "none";
    skipContainer.innerHTML = skipPopupHTML
        .replace("{{ timestamp }}", convertSecondsToMMSSMS(end))
        .replace(/{{ type }}/g, type)
        .replace("{{ textType }}", type == "op" ? "Opening" : "Ending");
    skipContainer.id = "skip-container";
    playerContainer.appendChild(skipContainer);
    waitForTimestamp(document.querySelector('video'), start, () => {
        console.log(`AniSkip: ${type} start time reached`);
        const videoElement = document.querySelector('video');
        if (videoElement && videoElement.currentTime > start + 1)
            return console.log("The user has skipped ahead, therefore won't show the skip popup."); // If the user has skipped ahead, don't show the popup
        let interacted = false;
        skipContainer.style.display = "flex";
        let skipButton = document.getElementById(`skip-${type}-button`);
        let dismissButton = document.getElementById(`dismiss-${type}-button`);
        const skipSegment = () => {
            console.log(`AniSkip: Skipping ${type} to ${end}`);
            const videoElm = document.querySelector('video');
            videoElm.currentTime = end;
            videoElm.play();
            skipContainer.style.display = "none";
            interacted = true;
        };
        const dismiss = () => {
            console.log(`AniSkip: Dismissed ${type} skip`);
            skipContainer.style.display = "none";
            interacted = true;
        };
        setTimeout(() => {
            if (interacted)
                return;
            console.log(`AniSkip: Auto skipping ${type} to ${end}`);
            skipSegment();
        }, 5000);
        skipButton.addEventListener('click', skipSegment);
        dismissButton.addEventListener('click', dismiss);
    });
}
function calculateSlider(startTimestamp, endTimestamp) {
    let elm = document.querySelector('video');
    if (elm && elm.duration) {
        const totalDuration = elm.duration;
        const startPercentage = (startTimestamp / totalDuration) * 100;
        const endPercentage = (endTimestamp / totalDuration) * 100;
        const marginLeft = startPercentage;
        const width = endPercentage - startPercentage;
        return {
            marginLeft: `${marginLeft}%`,
            width: `${width}%`
        };
    }
    else {
        console.error("Video element not found or invalid duration.");
        return null;
    }
}
function waitForElm(selector) {
    return new Promise((resolve, reject) => {
        if (document.querySelector(selector))
            return resolve(document.querySelector(selector));
        const observer = new MutationObserver(() => {
            if (document.querySelector(selector)) {
                resolve(document.querySelector(selector));
                observer.disconnect();
            }
        });
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
        setTimeout(() => {
            observer.disconnect();
            reject(new Error(`Timeout waiting for element with selector: ${selector}`));
        }, 10000);
    });
}
function waitForTimestamp(videoElement, targetTime, callback) {
    function checkTime() {
        if (videoElement.currentTime >= targetTime) {
            videoElement.removeEventListener('timeupdate', checkTime);
            callback();
        }
    }
    videoElement.addEventListener('timeupdate', checkTime);
}
function delay(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}
function encodeWithPlus(input) {
    return encodeURIComponent(input).replace(/%20/g, '+');
}
async function getPlayerState() {
    let playerState = null;
    // Retry fetching the data until it's available
    while (playerState == null || !playerState.seriesInfo || !playerState.metaItem?.content) {
        try {
            playerState = await _eval('core.transport.getState(\'player\')');
            if (playerState.seriesInfo && playerState.metaItem?.content) {
                break; // Data is available, break out of the loop
            }
        }
        catch (err) {
            console.error('Error fetching player state:', err);
        }
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
    const seriesInfoDetails = playerState.seriesInfo;
    const metaDetails = playerState.metaItem.content;
    return { seriesInfoDetails, metaDetails };
}
function convertSecondsToMMSSMS(seconds) {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = Math.floor(seconds % 60);
    const milliseconds = Math.round((seconds % 1) * 1000); // Extract milliseconds
    const formattedSeconds = remainingSeconds < 10 ? `0${remainingSeconds}` : `${remainingSeconds}`;
    const formattedMilliseconds = milliseconds < 100 ? `0${milliseconds}` : `${milliseconds}`;
    return `${minutes}:${formattedSeconds}:${formattedMilliseconds}`;
}
function _eval(js) {
    return new Promise((resolve, reject) => {
        try {
            const eventName = 'stremio-enhanced';
            const script = document.createElement('script');
            window.addEventListener(eventName, (data) => {
                script.remove();
                resolve(data.detail);
            }, { once: true });
            script.id = eventName;
            script.appendChild(document.createTextNode(`
                    var core = window.services.core;
                    var result = ${js};
            
                    if (result instanceof Promise) {
                        result.then((awaitedResult) => {
                            window.dispatchEvent(new CustomEvent("${eventName}", { detail: awaitedResult }));
                        });
                    } else {
                        window.dispatchEvent(new CustomEvent("${eventName}", { detail: result }));
                    }
                `));
            document.head.appendChild(script);
        }
        catch (err) {
            reject(err);
        }
    });
}
