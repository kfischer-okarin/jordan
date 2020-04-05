<template>
  <div ref="editor" id="editor">
    <div id="cards-list">
      <draggable v-model="annotations" @end="doMove" :move="checkMove">
        <transition-group>
          <Card v-for="ann in annotations" :annotation="ann" :key="ann.guid"/>
        </transition-group>
      </draggable>
    </div>
    <div id="youtubePlayer">
      <youtube :video-id="videoId" ref="youtube" @playing="playing" :width="600" :height="320"></youtube>
    </div>
    <div id="md_container">
      <textarea id="contentEditor" ref="contentEditor"></textarea>
      <button id="add" class="button md-button" @click="addAnnotation" v-if="isActvie">Add</button>
      <button id="update" class="button md-button" @click="editAnnotation" v-if="editId && isActvie">Update</button>
      <button id="cancel" class="button md-button" @click="cancelEdit" v-if="editId && isActvie">Cancel</button>
    </div>
    <button id="end" class="button md-button" @click="endStream" v-if="canEnd">End Stream</button>
  </div>
</template>

<script>
import SimpleMDE from 'simplemde';
import draggable from 'vuedraggable';
import Card from './Card.vue';
import mine from '../mine';

const vars = {
  simplemde: null,
};

export default {
  name: 'Editor',
  props: {
    videoId: String,
  },
  components: {
    Card,
    draggable,
  },
  data() {
    let editId;
    return {
      editId,
      annotations: [],
      videoDetail: {
        'video_id': '',
        'status': '',
        'title': '',
        'owner': '',
      },
      isActvie: false,
      canEnd: false
    };
  },
  created() {
    if (!localStorage.userInfo || !JSON.parse(localStorage.userInfo).token) {
      this.$router.push('/login');
    }
    if (!this.videoId) {
      this.$router.push('/videos');
    }
    
    this.getVideoDetail();
    
  },
  mounted() {
    vm.$refs.youtube = this.$refs.youtube;
    vars.simplemde = new SimpleMDE({
      element: this.$refs.contentEditor,
      placeholder: 'Type here...',
      promptURLs: true,
      toolbar: ['heading', 'bold', 'italic', 'strikethrough', 'clean-block', '|',
        'quote', 'unordered-list', 'ordered-list', 'horizontal-rule', '|',
        'link', 'image', {
          name: 'custom',
          action: function customFunction(editor) {
            const cm = editor.codemirror;
            const stat = vars.simplemde.getState(cm);
            const { options } = editor;
            let bibleVerse = prompt('Enter: Book Chapter:Verse[-Verse]');
            if (bibleVerse) {
              bibleVerse = bibleVerse.split(' ').join('_');
              console.log(bibleVerse);
              let url = 'javascript:vm.$refs.card.openBibleModal("' + bibleVerse + '")';
              /* url = url.concat(bibleVerse); */
              if (/editor-preview-active/.test(cm.getWrapperElement().lastChild.className)) {
                return;
              }
              let text;
              let start = options.insertTexts.link[0];
              let end = options.insertTexts.link[1];
              const startPoint = cm.getCursor('start');
              const endPoint = cm.getCursor('end');
              if (url) {
                end = end.replace('#url#', url);
              }
              if (stat.link) {
                text = cm.getLine(startPoint.line);
                start = text.slice(0, startPoint.ch);
                end = text.slice(startPoint.ch);
                cm.replaceRange(start + end, {
                  line: startPoint.line,
                  ch: 0,
                });
              } else {
                text = cm.getSelection();
                cm.replaceSelection(start + text + end);

                startPoint.ch += start.length;
                if (startPoint !== endPoint) {
                  endPoint.ch += start.length;
                }
              }
              cm.setSelection(startPoint, endPoint);
              cm.focus();
            }
            console.log(cm);
          },
          className: 'fa fa-book',
          title: 'Bible Verse',
        }, '|', 'preview', 'guide',
        '|',
      ],
    });
    this.getAnnotations();
  },
  computed: {
    player() {
      return this.$refs.youtube.player
    }
  },
  methods: {
    playVideo() {
      this.player.playVideo()
    },
    playing() {
      console.log('playing')
    },
    getAnnotations(){
      mine.getRequestWithAuth('/videos/' + this.videoId + '/annotations').then((data) => {
        for(var i = 0; i < data.length; i++) {
          this.annotations.push({
            "guid": Math.random().toString(36).substring(2),
            "id": data[i].id,
            "timestamp": data[i].video_timestamp,
            "content": data[i].payload.content,
            "active": this.isActvie
          });
        }
      });
    },
    getVideoDetail() {
      mine.getRequestWithAuth('/videos/' + this.videoId).then((res) => {
        this.videoDetail.video_id = res.youtube_id;
        this.videoDetail.status = res.status;
        this.videoDetail.title = res.title;
        this.videoDetail.owner = res.user.name;
        this.isActvie = res.status == 'upcoming' || res.status == 'streaming';
        this.canEnd = res.status == 'streaming';
        });
    },
    addAnnotation() {
      if (vars.simplemde.value()) {
        const payload = {"content": vars.simplemde.value()}
        mine.sendRequestWithAuth('/videos/' + this.videoId + '/annotations', {'payload': payload}, 'POST').then((data) => {
          const newAnnotation = {
            "guid": Math.random().toString(36).substring(2),
            "id": data.id,
            "timestamp": null,
            "content": data.payload.content,
            "active": this.isActvie
          }
          this.annotations.push(newAnnotation);
          this.cancelEdit();
          vars.simplemde.value('');
          this.scrollDown();
        });
      }
    },
    deleteAnnotation(annotationId) {
      mine.sendRequestWithAuthNoRes('/annotations/' + annotationId, '', 'DELETE').then((data) => {
        this.annotations = this.annotations.filter(function(annotation) {
          if (annotation.id == annotationId) {
            return false;
          }
          return true;
        });
        if(this.editId && this.editId === annotationId) {
          this.cancelEdit();
        }
      });
    },
    loadForEdit(annotationId, content) {
      this.editId = annotationId;
      vars.simplemde.value(content);
      vm.$refs.youtube.player.getPlayerState().then(value => {
        if (value == 1) {
          vm.$refs.youtube.player.getCurrentTime().then(time => {
            console.log(Math.round(time));
          });
        }
      });
    },
    editAnnotation() {
      const payload = {"content": vars.simplemde.value()}
      mine.sendRequestWithAuth('/annotations/' + this.editId, {'payload': payload}, 'PATCH').then((res) => {
        for (var i = 0; i < this.annotations.length; i++) {
          if (this.annotations[i].id === this.editId) {
            this.annotations[i].guid = Math.random().toString(36).substring(2);
            this.annotations[i].content = res.payload.content;
            this.annotations[i].timestamp = res.video_timestamp;
            this.cancelEdit();
            vars.simplemde.value('');
            return;
          }
        }
      });
    },
    cancelEdit() {
      this.editId = '';
    },
    doMove(evt) {
      console.log("moved");
      this.updateOrder();
      return true;
    },
    checkMove(evt){
      return this.isActvie;
    },
    updateOrder() {
      const order = this.annotations.map(ann => ann.id);
      mine.sendRequestWithAuthNoRes('/videos/' + this.videoId + '/annotations/order', order, 'PUT').then((data) => {
        console.log('Order updated...');
      });
    },
    publishAnnotation(annotationId) {
      vm.$refs.youtube.player.getCurrentTime().then(time => {
        const secTime = Math.round(time);
        mine.sendRequestWithAuthNoRes('/annotations/' + annotationId + '/publish', {'video_timestamp': secTime}, 'POST').then((data) => {
          for (var i = 0; i < this.annotations.length; i++) {
            if (this.annotations[i].id === annotationId) {
              this.annotations[i].timestamp = secTime;
              this.annotations[i].guid = Math.random().toString(36).substring(2);
              this.canEnd = true;
              return;
            }
          }
        });
      });
    },
    endStream() {
      mine.sendRequestWithAuth('/videos/' + this.videoId, {"status": "streamed"}, "PATCH").then((res) => {
        for (var i = 0; i < this.annotations.length; i++) {
          this.annotations[i].active = false;
          this.annotations[i].guid = Math.random().toString(36).substring(2);
        }
      });
    },
    scrollDown() {
      let container = this.$el.querySelector("#cards-list");
        setTimeout(function () {
          container.scrollTop = container.scrollHeight;
        }, 500);
    }
  },
};
</script>

<style>
#editor {
  padding: 10px 100px;
  position: relative;
}
#md_container {
  padding: 5px 20px;
  width: 600px;
}

.CodeMirror, .CodeMirror-scroll {
  min-height: 180px;
  height: 180px;
}

.md-button {
  display: block;
  margin-top: -25px;
  background-color:#E0E5EC;
  width:100px;
  height:30px;
  float: left;
  margin-right: 10px;
  cursor: pointer;
}

.button, .CodeMirror, .editor-toolbar{
  /* Basic styling and alignment */
  border-radius:4px;
  border: 0;
    /* Basic styling and alignment */
  /* For Neumorphism Effect */
  background-color:#E0E5EC;
  box-shadow: 3px 3px 6px rgb(163,177,198,0.6), -9px -9px 16px    rgba(255,255,255, 0.5);
    /* For Neumorphism Effect */
}

.editor-toolbar {
  margin-bottom: -5px;
}

#end {
  position: absolute;
  right: 580px;
  bottom: 20px;
  color: red;
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

sup+p, sup+t, t p{
  display: inline;
}

#cards-list {
  float: right;
  display: block;
  position: absolute;
  right: 180px;
  width: 560px;
  height: 90%;
  padding: 5px;
  overflow-y: scroll;
}

.editor-preview, .editor-toolbar {
  background-color:#E0E5EC;
}

a {
  text-decoration: none;
  color: #40739e;
}
</style>
