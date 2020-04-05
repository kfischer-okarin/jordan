<template>
  <div ref="streamer" id="streamer">
  	<div id="content">
      <h2 class="title">Jordan - {{ title }}</h2>
  	  <div id="youtubePlayer">
      	<youtube :video-id="videoId" ref="youtube_str" @playing="playing" :width="500" :height="290"></youtube>
      </div>
      <div id="annotations" >
      	<!-- <i class="far fa-heart icon-button" @click="favAnnotation(annotation.id)"></i>
      	<i class="fas fa-heart icon-button" @click="unfavAnnountation(annotation.id)"></i>
      	<span class="timestamp">{{ annotation.timestamp }}</span>
      	<div class="annotation-content" v-html="simplemde.prototype.markdown(annotation.content)"></div>
      	<BibleModal v-if="bibleVerse" :bibleRef="bibleVerse"/> -->
      	<Card v-for="ann in annotations" :annotation="ann" :key="ann.guid"/>
      </div>
  	</div>
  </div>

  </div>
</template>

<script>
  import Card from './Card.vue';
  import SimpleMDE from 'simplemde';
  import mine from '../mine';

  // let htmlContent;
  export default {
    name: 'Stream',
    props: {
      videoId: String,
    },
    components: {
      Card,
    },
    data: () => ({
      simplemde: SimpleMDE,
      annotations : [],
      title: ''
    }),
    computed: {
      player() {
        return this.$refs.youtube_str.player;
      }
    },
    created() {
      this.getVideoDetail();
    },
    mounted() {
      vm.$refs.youtube_str = this.$refs.youtube_str;
      this.getAnnotations();
      const socket = new WebSocket('wss://jordan-app-test.herokuapp.com/cable');
	  const channelIdentifier = JSON.stringify({
	    'channel': 'ViewerChannel',
	    'youtube_id': this.videoId
	  });

	  const subscribe = () => {
	    const subscribeMessage = { command: 'subscribe', identifier: channelIdentifier };
	    socket.send(JSON.stringify(subscribeMessage));
	  };

	  const isAnnotationMessage = (payload) => payload.identifier === channelIdentifier && payload.message;
	  const getAnnotationFromPayload = (payload) => payload.message;
	  socket.onopen = (event) => {
	    subscribe();
	  };

	  socket.onmessage = (event) => {
	    const payload = JSON.parse(event.data);
	    if (isAnnotationMessage(payload)) {
	      const annotation = getAnnotationFromPayload(payload);
	      console.log(annotation);
	      this.annotations.push({
	              "guid": Math.random().toString(36).substring(2),
	              "id": Math.random().toString(36).substring(2),
	              "timestamp": annotation.video_timestamp,
	              "content": annotation.payload.content
	            });
        this.scrollDown();
	    }
	  };
      // htmlContent = SimpleMDE.prototype.markdown(this.annotation.content);
    },
    methods: {
      playVideo() {
        this.player.playVideo();
      },
      playing() {
        console.log('playing');
      },
      getAnnotations(){
        mine.getRequestWithoutAuth('/videos/' + this.videoId + '/annotations').then((data) => {
          for(var i = 0; i < data.length; i++) {
            this.annotations.push({
              "guid": Math.random().toString(36).substring(2),
              "id": data[i].id,
              "timestamp": data[i].video_timestamp,
              "content": data[i].payload.content
            });
          }
        });
      },
      favAnnotation(ann_id) {
        console.log('playing');
      },
      unfavAnnotation(ann_id) {
        console.log('playing');
      },
      scrollDown() {
        let container = this.$el.querySelector("#annotations");
        setTimeout(function () {
          container.scrollTop = container.scrollHeight;
        }, 500);
      },
      getVideoDetail() {
      mine.getRequestWithoutAuth('/videos/' + this.videoId).then((res) => {
        this.title = res.title;
        });
      },
    }
  }
</script>

<style scoped>
div.card {
  padding: 10px;
  background: #e0e5ec;
  margin: auto;
  width: 400px;
  border-radius: 2px;
  box-shadow:
  #e0e5ec 0px 0px 2px 2px,
  #a3b1c6 4px 4px 8px,
  #ffffff -4px -4px 8px;
  margin-bottom: 20px;
  cursor: grab;
}

#content {
  width: 900px;
  margin: 0 auto;
}

#annotations {
  width: 450px;
  margin: 0 auto;
  height: 280px;
  overflow: auto;
  padding: 10px;
}

i.icon-button {
  float: right;
  margin-top: -5px;
  margin-left: 10px;
  cursor: pointer;
}

h1, h2, h3, h4, h5, h6 {
  margin: 3px 3px;
  margin-block-start: 0px;
  margin-block-end: 0px
}

p {
  margin-block-start: 0px;
    margin-block-end: 0px;
}

#youtubePlayer {
  width: 480px;
  margin: 0 auto;
}
.title {
  position: relative;
  margin: 0 auto;
  width: max-content;
}

</style>